import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:al_andalus/generated/l10n.dart';

/// Custom explicitly mapped failure types for biometric authentication
enum BiometricFailure {
  notSupported,
  notEnrolled,
  lockedOut,
  permanentlyLockedOut,
  canceled,
  notCached,
  unknown;

  String get message {
    switch (this) {
      case BiometricFailure.notSupported:
        return S.current.biometricNotSupported;
      case BiometricFailure.notEnrolled:
        return S.current.biometricNotEnrolled;
      case BiometricFailure.lockedOut:
        return S.current.biometricLockedOut;
      case BiometricFailure.permanentlyLockedOut:
        return S.current.biometricPermanentlyLockedOut;
      case BiometricFailure.canceled:
        return S.current.biometricCanceled;
      case BiometricFailure.notCached:
        return S.current.biometricNotCached;
      case BiometricFailure.unknown:
        return S.current.biometricUnknown;
    }
  }
}

/// Represents the result of a biometric authentication operation.
class BiometricResult {
  final bool success;
  final String? phone;
  final String? password;
  final BiometricFailure? failure;

  const BiometricResult.success(this.phone, this.password)
      : success = true,
        failure = null;

  const BiometricResult.failure(this.failure)
      : success = false,
        phone = null,
        password = null;
}

/// A robust Biometric Authentication Service implementing 2026 Flutter standards.
/// Designed for easy injection into an 'm_cubit' pattern.
class BiometricAuthService {
  final LocalAuthentication _localAuth;
  final FlutterSecureStorage _secureStorage;

  /// Private constant keys for storing the user credentials explicitly
  static const String _userPhoneKey = 'secure_user_phone';
  static const String _userPasswordKey = 'secure_user_password';
  static const String _biometricEnabledKey = 'secure_biometric_enabled';

  BiometricAuthService({
    LocalAuthentication? localAuth,
    FlutterSecureStorage? secureStorage,
  })  : _localAuth = localAuth ?? LocalAuthentication(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<bool> isBiometricEnabled() async {
    final enabled = await _secureStorage.read(key: _biometricEnabledKey);
    return enabled == 'true';
  }

  Future<bool> hasCredentialsSaved() async {
    final phone = await _secureStorage.read(key: _userPhoneKey);
    final password = await _secureStorage.read(key: _userPasswordKey);
    return phone != null && phone.isNotEmpty && password != null && password.isNotEmpty;
  }

  Future<void> enableBiometric() async {
    await _secureStorage.write(key: _biometricEnabledKey, value: 'true');
  }

  /// 1. Hardware Validation
  /// Checks if the device supports biometrics (FaceID/Fingerprint) and if the user 
  /// has enrolled at least one biometric identity.
  Future<BiometricFailure?> validateHardware() async {
    try {
      final bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();

      if (!canAuthenticate) {
        return BiometricFailure.notSupported;
      }

      final List<BiometricType> availableBiometrics =
          await _localAuth.getAvailableBiometrics();

      if (availableBiometrics.isEmpty) {
        return BiometricFailure.notEnrolled;
      }

      return null; // Hardware is valid and enrolled
    } catch (_) {
      return BiometricFailure.unknown;
    }
  }

  /// 2. Secure Authentication & 3. Security Lifecycle & 4. Error Mapping
  /// Triggers the OS-level biometric dialog and securely returns the user credentials if successful.
  Future<BiometricResult> authenticateAndRetrieveCredentials({
    String? localizedReason,
  }) async {
    // 1. Pre-flight Hardware check
    final hardwareCheck = await validateHardware();
    if (hardwareCheck != null) {
      return BiometricResult.failure(hardwareCheck);
    }

    // 2. Pre-flight check if biometric is enabled and credentials are cached
    final bool isEnabled = await isBiometricEnabled();
    if (!isEnabled) {
      return const BiometricResult.failure(BiometricFailure.notCached);
    }

    final String? cachedPhone = await _secureStorage.read(key: _userPhoneKey);
    final String? cachedPassword = await _secureStorage.read(key: _userPasswordKey);

    if (cachedPhone == null || cachedPhone.trim().isEmpty || 
        cachedPassword == null || cachedPassword.trim().isEmpty) {
      return const BiometricResult.failure(BiometricFailure.notCached);
    }

    try {
      // 2. Trigger OS-level biometric dialog with safe constraints
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: localizedReason ?? S.current.biometricReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true, // Prevents PIN fallback explicitly
          useErrorDialogs: true,
          sensitiveTransaction: true,
        ),
      );

      if (didAuthenticate) {
        // 3. Unlocking the stored User credentials only after successful verification
        final String? phone = await _secureStorage.read(key: _userPhoneKey);
        final String? password = await _secureStorage.read(key: _userPasswordKey);
        
        if (phone != null && phone.trim().isNotEmpty && password != null && password.trim().isNotEmpty) {
          return BiometricResult.success(phone, password);
        } else {
          return const BiometricResult.failure(BiometricFailure.unknown);
        }
      } else {
        return const BiometricResult.failure(BiometricFailure.canceled);
      }
    } on PlatformException catch (e) {
      // 4. Custom Error Mapping handling strict platform exceptions
      switch (e.code) {
        case auth_error.notEnrolled:
          return const BiometricResult.failure(BiometricFailure.notEnrolled);
        case auth_error.lockedOut:
          return const BiometricResult.failure(BiometricFailure.lockedOut);
        case auth_error.permanentlyLockedOut:
          return const BiometricResult.failure(BiometricFailure.permanentlyLockedOut);
        default:
          return const BiometricResult.failure(BiometricFailure.unknown);
      }
    } catch (_) {
      return const BiometricResult.failure(BiometricFailure.unknown);
    }
  }

  /// Safely writes the credentials (Called upon standard login verification process).
  Future<void> saveCredentialsSecurely({required String phone, required String password}) async {
    await _secureStorage.write(key: _userPhoneKey, value: phone);
    await _secureStorage.write(key: _userPasswordKey, value: password);
  }
  
  /// Deletes the credentials and disables biometric (Called upon app logout event or explicit removal).
  Future<void> deleteSecureToken() async {
    await _secureStorage.delete(key: _userPhoneKey);
    await _secureStorage.delete(key: _userPasswordKey);
    await _secureStorage.delete(key: _biometricEnabledKey);
  }

  Future<bool> authenticateForEnrollment({
    String localizedReason = 'يرجى المصادقة لتفعيل الدخول البيومتري',
  }) async {
    final hardwareCheck = await validateHardware();
    if (hardwareCheck != null) return false;

    try {
      return await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
          sensitiveTransaction: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
