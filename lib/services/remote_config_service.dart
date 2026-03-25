import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  RemoteConfigService._();

  static final RemoteConfigService instance = RemoteConfigService._();

  late final FirebaseRemoteConfig _rc;

  /// Initialize Firebase and Remote Config.
  /// Call this once before using any getters.
  Future<void> init() async {
    _rc = FirebaseRemoteConfig.instance;

    await _rc.setDefaults(
      {
        'show_old_price': true,
        'show_guest': true,
      },
    );

    final settings = RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: kDebugMode ? const Duration(seconds: 30) : const Duration(hours: 6),
    );

    await _rc.setConfigSettings(settings);

    fetchAndActivate();
  }

  /// Pull latest values from the server and activate them.
  /// Returns true if new values were activated.
  Future<bool> fetchAndActivate() async {
    try {
      await _rc.fetch();
      final b = await _rc.activate();
      return b;
    } on FirebaseException catch (e) {
      debugPrint('Remote Config fetch error: ${e.message}');
      return false;
    }
  }

  // Typed getters ----------------------------------------------------------

  bool get showOldPrice => _rc.getBool('show_old_price');

  bool get showGuest => _rc.getBool('show_guest');
}
