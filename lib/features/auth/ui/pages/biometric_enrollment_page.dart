import 'package:al_andalus/core/app/app_provider.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/core/widgets/my_text_form_widget.dart';
import 'package:al_andalus/services/biometric_auth_service.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';
import '../../../../router/go_router.dart';
import '../../../../core/util/snack_bar_message.dart';

class BiometricEnrollmentPage extends StatefulWidget {
  final bool fromLogin;
  
  const BiometricEnrollmentPage({super.key, this.fromLogin = false});

  @override
  State<BiometricEnrollmentPage> createState() => _BiometricEnrollmentPageState();
}

class _BiometricEnrollmentPageState extends State<BiometricEnrollmentPage> {
  bool _isLoading = true;
  bool _isManualInputRequired = false;
  bool _isError = false;
  bool _isEnabled = false;

  final _formKey = GlobalKey<FormState>();
  String _phone = '';
  String _password = '';

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final service = BiometricAuthService();
    final enabled = await service.isBiometricEnabled();
    final hasCredentials = await service.hasCredentialsSaved();
    
    if (mounted) {
      setState(() {
        _isEnabled = enabled;
        _isManualInputRequired = !hasCredentials;
        _isLoading = false;
      });
    }
  }

  void _completeFlow() {
    if (widget.fromLogin) {
      context.goNamed(RouteName.home);
      if (AppProvider.insurancePage.isNotEmpty) {
        context.pushNamed(
          RouteName.insurancePage,
          queryParameters: AppProvider.insurancePage,
        );
      }
    } else {
      context.pop();
    }
  }

  Future<void> _enrollBiometric() async {
    if (_isManualInputRequired) {
      if (!_formKey.currentState!.validate()) return;
    }

    setState(() {
      _isLoading = true;
      _isError = false;
    });

    final service = BiometricAuthService();

    // 1. Hardware Validate
    final hardwareCheck = await service.validateHardware();
    if (hardwareCheck != null) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
      if (mounted) {
        NoteMessage.showErrorSnackBar(
          context: context,
          message: hardwareCheck.message,
        );
      }
      return;
    }

    // 2. Trigger OS Authentication exclusively
    final bool didAuthenticate = await service.authenticateForEnrollment(
      localizedReason: 'يرجى التحقق من بصمتك أو وجهك لتفعيل الميزة',
    );
    
    if (didAuthenticate) {
       if (_isManualInputRequired) {
         await service.saveCredentialsSecurely(phone: _phone, password: _password);
       }
       await service.enableBiometric();
       
       if (mounted) {
         NoteMessage.showSuccessSnackBar(
           context: context,
           message: 'تم تفعيل الدخول البيومتري بنجاح',
         );
       }
       _completeFlow();
    } else {
       setState(() {
         _isLoading = false;
         _isError = true;
       });
    }
  }

  Future<void> _disableBiometric() async {
    NoteMessage.showCheckDialog(
      context,
      text: S.of(context).removeBiometricWarning,
      textButton: 'إيقاف الميزة',
      onConfirm: (confirm) async {
        if (!confirm) return;
        await BiometricAuthService().deleteSecureToken();
        if (context.mounted) {
          NoteMessage.showSuccessSnackBar(
            context: context,
            message: S.of(context).removeBiometricSuccess,
          );
        }
        _completeFlow();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBarWidget(
        titleText: 'الإعدادات البيومترية',
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0).r,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_isEnabled)
              MyButton(
                text: _isError ? 'فعل مجدداً' : 'فعل الآن',
                onTap: _enrollBiometric,
              )
            else
              MyButton(
                text: 'إيقاف الميزة',
                color: Colors.redAccent,
                onTap: _disableBiometric,
              ),
            10.0.verticalSpace,
            OutLineButton(
              text: 'ربما لاحقاً',
              onTap: _completeFlow,
              color: Colors.white,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0).r,
        child: Column(
          children: [
            20.0.verticalSpace,
            if (_isError && !_isEnabled) ...[
              Container(
                padding: const EdgeInsets.all(16.0).r,
                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  borderRadius: BorderRadius.circular(12).r,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white, size: 40),
                    15.0.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DrawableText(
                            text: 'فشل في عملية تفعيل الدخول البيومتري',
                            color: Colors.white,
                            fontFamily: FontManager.bold.name,
                            size: 14.0.sp,
                          ),
                          5.0.verticalSpace,
                          DrawableText(
                            text: 'يرجى المحاولة مرة أخرى أو إستخدام طريقة دخول مختلفة',
                            color: Colors.white,
                            size: 12.0.sp,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              30.0.verticalSpace,
            ],
            DrawableText(
              text: _isEnabled ? 'الميزة مفعلة' : 'طريقة أسرع لتسجيل الدخول',
              fontFamily: FontManager.bold.name,
              size: 18.0.sp,
            ),
            20.0.verticalSpace,
            DrawableText(
              text: _isEnabled 
                ? 'ميزة الدخول بالبصمة أو الوجه مفعلة حالياً. يمكنك إيقافها من خلال الزر في الأسفل.' 
                : 'استخدم تسجيل الدخول البيومتري ببصمة إصبعك أو وجهك للوصول إلى حسابك بشكل أسرع وأسهل.\n\nيمكنك تشغيل هذه الميزة أو إيقافها في أي وقت من خلال الإعدادات.',
              textAlign: TextAlign.center,
              color: Colors.grey.shade600,
              size: 14.0.sp,
            ),
            40.0.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.face_retouching_natural, size: 80, color: AppColorManager.black),
                20.0.horizontalSpace,
                const Icon(Icons.fingerprint, size: 80, color: AppColorManager.black),
              ],
            ),
            40.0.verticalSpace,
            if (_isManualInputRequired && !_isEnabled) ...[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DrawableText(
                      text: 'يرجى إدخال بيانات الدخول لإعادة تفعيل الميزة:',
                      fontFamily: FontManager.bold.name,
                    ),
                    10.0.verticalSpace,
                    MyTextFormOutLineWidget(
                      validator: (p0) => p0.validateEmpty,
                      hint: S.of(context).phoneNumber,
                      keyBordType: TextInputType.phone,
                      onChanged: (val) => _phone = val,
                    ),
                    MyTextFormOutLineWidget(
                      validator: (p0) => p0.validateEmpty,
                      keyBordType: TextInputType.number,
                      hint: S.of(context).pinCode,
                      obscureText: true,
                      onChanged: (val) => _password = val,
                    ),
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
