import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class PinCodeWidget extends StatelessWidget {
  const PinCodeWidget({
    super.key,
    this.onCompleted,
    this.onChange,
    this.validator,
  });

  final Function(String)? onCompleted;
  final Function(String)? onChange;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    // تعريف التصميم الافتراضي (للمربعات الفارغة)
    final defaultPinTheme = PinTheme(
      width: 56.0.r,
      height: 56.0.r,
      textStyle: TextStyle(
        fontSize: 22.0.r,
        color: AppColorManager.mainColorDark,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), // زوايا دائرية
        border: Border.all(color: Colors.grey.shade300), // إطار رمادي فاتح جداً
      ),
    );

    // تعريف تصميم المربعات عند الكتابة (التي تحتوي على أرقام)
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppColorManager.mainColor), // إطار غامق
      ),
    );
    return Center(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Pinput(
          length: 5,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: defaultPinTheme.copyDecorationWith(
            border: Border.all(color: AppColorManager.mainColor),
            borderRadius: BorderRadius.circular(15),
          ),
          submittedPinTheme: submittedPinTheme,
          onCompleted: onCompleted,
          onChanged: onChange,
          validator: validator,
        ),
      ),
    );
  }
}

//Big shit
