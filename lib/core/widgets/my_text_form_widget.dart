import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../app/app_provider.dart';
import '../strings/app_color_manager.dart';
import '../util/my_style.dart';
/*import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';*/

class MyTextFormOutLineWidget extends StatefulWidget {
  const MyTextFormOutLineWidget({
    super.key,
    this.label = '',
    this.hint = '',
    this.helperText = '',
    this.maxLines = 1,
    this.obscureText = false,
    this.textAlign = TextAlign.start,
    this.maxLength = 1000,
    this.onChanged,
    this.controller,
    this.keyBordType,
    this.innerPadding,
    this.enable,
    this.icon,
    this.color = Colors.black,
    this.initialValue,
    this.textDirection,
    this.validator,
    this.iconWidget,
    this.iconWidgetLift,
    this.onChangedFocus,
    this.onTap,
    this.autofillHints,
    this.labelText,
    this.textInputAction,
    this.onFieldSubmitted,
    this.inputFormatters,
  });

  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final bool? enable;
  final List<TextInputFormatter>? inputFormatters;
  final String label;
  final String? labelText;
  final String hint;
  final String? helperText;
  final dynamic icon;
  final Widget? iconWidget;
  final Widget? iconWidgetLift;
  final Color color;
  final int maxLines;
  final int maxLength;
  final bool obscureText;
  final TextAlign textAlign;
  final Function(String)? onChanged;
  final Function(bool)? onChangedFocus;
  final Function()? onTap;
  final List<String>? autofillHints;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyBordType;
  final EdgeInsets? innerPadding;
  final String? initialValue;
  final TextDirection? textDirection;

  @override
  State<MyTextFormOutLineWidget> createState() => _MyTextFormOutLineWidgetState();
}

class _MyTextFormOutLineWidgetState extends State<MyTextFormOutLineWidget> {
  @override
  Widget build(BuildContext context) {
    final padding = widget.innerPadding ?? const EdgeInsets.symmetric(horizontal: 24.0).w;

    bool obscureText = widget.obscureText;
    Widget? suffixIcon;
    Widget? eye;
    VoidCallback? onChangeObscure;

    if (widget.iconWidget != null) {
      suffixIcon = widget.iconWidget!;
    } else if (widget.icon != null) {
      suffixIcon = Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0).r,
        child: ImageMultiType(
          color: AppColorManager.mainColorDynamic,
          url: widget.icon!,
          height: 15.0.r,
          width: 15.0.r,
        ),
      );
    }

    if (obscureText) {
      eye = StatefulBuilder(
        builder: (context, state) {
          return IconButton(
            splashRadius: 0.01,
            onPressed: () {
              state(() => obscureText = !obscureText);
              if (onChangeObscure != null) onChangeObscure!();
            },
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
          );
        },
      );
    }

    final border = OutlineInputBorder(
      borderSide: BorderSide(color: AppColorManager.cd),
      borderRadius: BorderRadius.circular(10.0.r),
    );

    final errorBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColorManager.red,
        width: 1.0.spMin,
      ),
      borderRadius: BorderRadius.circular(10.0.r),
    );

    final inputDecoration = InputDecoration(
      contentPadding: padding,
      errorBorder: errorBorder,
      border: border,
      focusedBorder: border,
      enabledBorder: border,
      helperText: widget.helperText,
      helperStyle: const TextStyle(color: Colors.grey),
      fillColor: AppColorManager.f9,
      label: DrawableText(
        text: widget.label,
        color: AppColorManager.grey,
        size: 16.0.spMin,
      ),
      counter: const SizedBox(),
      hintText: widget.hint,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintTextDirection: widget.textDirection,
      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
      filled: false,

      prefixIcon: widget.iconWidget ?? suffixIcon,
      suffixIcon: widget.iconWidgetLift ?? eye,
    );

    final textStyle = TextStyle(
      fontSize: 16.0.spMin,
    );

    return StatefulBuilder(
      builder: (context, state) {
        onChangeObscure = () => state(() {});
        return Column(
          children: [
            if (widget.labelText != null)
              DrawableText(
                text: widget.labelText!,
                padding: EdgeInsets.only(bottom: 10.0).r,
                matchParent: true,
              ),
            TextFormField(
              autofillHints: widget.autofillHints,
              onTap: () => widget.onTap?.call(),
              validator: widget.validator,
              decoration: inputDecoration,
              maxLines: widget.maxLines,
              readOnly: !(widget.enable ?? true),
              initialValue: widget.initialValue,
              obscureText: obscureText,
              textAlign: widget.textAlign,
              onChanged: widget.onChanged,
              style: textStyle,
              textDirection: widget.textDirection,
              maxLength: widget.maxLength,
              controller: widget.controller,
              textInputAction: widget.textInputAction,
              onFieldSubmitted: widget.onFieldSubmitted,
              inputFormatters: widget.inputFormatters,
              keyboardType: widget.keyBordType,
            ),
          ],
        );
      },
    );
  }
}

class MyEditTextWidget extends StatelessWidget {
  const MyEditTextWidget({
    super.key,
    this.hint = '',
    this.maxLines = 1,
    this.textAlign,
    this.maxLength = 1000,
    this.onChanged,
    this.controller,
    this.keyBordType,
    this.innerPadding,
    this.backgroundColor,
    this.focusNode,
    this.obscureText = false,
    this.icon,
    this.enable,
    this.radios,
    this.textInputAction,
    this.onFieldSubmitted,
    this.inputFormatters,
  });

  final String hint;
  final int maxLines;
  final int maxLength;
  final bool obscureText;
  final bool? enable;
  final TextAlign? textAlign;
  final Function(String val)? onChanged;
  final TextEditingController? controller;
  final TextInputType? keyBordType;
  final EdgeInsets? innerPadding;
  final Color? backgroundColor;
  final Widget? icon;
  final FocusNode? focusNode;
  final double? radios;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    bool obscureText = this.obscureText;
    Widget? suffixIcon;
    late VoidCallback onChangeObscure;

    if (icon != null) suffixIcon = icon;

    if (obscureText) {
      suffixIcon = StatefulBuilder(
        builder: (context, state) {
          return InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              state(() => obscureText = !obscureText);
              onChangeObscure();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0).r,
              child: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                size: 20.0.spMin,
              ),
            ),
          );
        },
      );
    }

    final border = OutlineInputBorder(
      borderSide: BorderSide(
        color: backgroundColor ?? AppColorManager.offWhit.withValues(alpha: 0.27),
      ),
      borderRadius: BorderRadius.circular(radios ?? 10.0.r),
    );

    final inputDecoration = InputDecoration(
      hintText: hint,
      hintStyle: MyStyle.hintStyle,
      contentPadding: innerPadding ?? const EdgeInsets.symmetric(horizontal: 10.0).w,
      counter: const SizedBox(),
      enabledBorder: border,
      focusedErrorBorder: border,
      disabledBorder: border,
      focusedBorder: border,
      errorMaxLines: 0,
      constraints: BoxConstraints(maxWidth: .9.sw, minWidth: .3.sw),
      border: border,
      fillColor: backgroundColor ?? AppColorManager.offWhit.withValues(alpha: 0.27),
      filled: true,
      enabled: enable ?? true,
      prefixIcon: suffixIcon ?? 0.0.verticalSpace,
      prefixIconConstraints: BoxConstraints(maxWidth: 80.0.spMin, minHeight: 50.0.spMin),
    );

    return StatefulBuilder(
      builder: (context, state) {
        onChangeObscure = () => state(() {});
        return TextFormField(
          obscureText: obscureText,
          decoration: inputDecoration,
          maxLines: maxLines,
          textAlign: textAlign ?? TextAlign.start,
          onChanged: onChanged,
          style: MyStyle.textFormTextStyle,
          focusNode: focusNode,
          maxLength: maxLength,
          controller: controller,
          keyboardType: keyBordType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          onFieldSubmitted: onFieldSubmitted,
        );
      },
    );
  }
}

class RectCustomClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) => Rect.fromLTWH(3.w, 0, size.width - 6.w, size.height);

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => oldClipper != this;
}

/*
class MyTextFormPhoneWidget extends StatefulWidget {
  const MyTextFormPhoneWidget({
    super.key,
    this.label = '',
    this.hint = '',
    this.helperText = '',
    this.maxLines = 1,
    this.obscureText = false,
    this.textAlign = TextAlign.start,
    this.maxLength = 1000,
    this.onChanged,
    this.controller,
    this.keyBordType,
    this.innerPadding,
    this.enable,
    this.icon,
    this.color = Colors.black,
    this.initialValue,
    this.textDirection,
    this.validator,
    this.iconWidget,
    this.iconWidgetLift,
    this.onChangedFocus,
    this.onTap,
    this.autofillHints,
    this.errorText,
    this.required = false,
  });

  final bool? enable;
  final String label;
  final String hint;
  final String? helperText;
  final dynamic icon;
  final Widget? iconWidget;
  final Widget? iconWidgetLift;
  final Color color;
  final int maxLines;
  final int maxLength;
  final bool obscureText;
  final TextAlign textAlign;
  final Function(PhoneNumber)? onChanged;
  final Function(bool)? onChangedFocus;
  final Function()? onTap;
  final bool required;
  final String? errorText;
  final List<String>? autofillHints;
  final String? Function(PhoneNumber? phone)? validator;
  final TextEditingController? controller;
  final TextInputType? keyBordType;
  final EdgeInsets? innerPadding;
  final String? initialValue;
  final TextDirection? textDirection;

  @override
  State<MyTextFormPhoneWidget> createState() => _MyTextFormPhoneWidgetState();
}

class _MyTextFormPhoneWidgetState extends State<MyTextFormPhoneWidget> {
  FocusNode? focusNode;

  @override
  void initState() {
    if (widget.onChangedFocus != null) {
      focusNode = FocusNode()
        ..addListener(() {
          widget.onChangedFocus!.call(focusNode!.hasFocus);
        });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final padding = widget.innerPadding ?? const EdgeInsets.symmetric(horizontal: 24.0).w;

    bool obscureText = widget.obscureText;
    Widget? suffixIcon;
    Widget? eye;
    VoidCallback? onChangeObscure;

    if (widget.iconWidget != null) {
      suffixIcon = widget.iconWidget!;
    } else if (widget.icon != null) {
      suffixIcon = Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0).r,
        child: ImageMultiType(
          color: AppColorManager.mainColorDynamic,
          url: widget.icon!,
          height: 15.0.r,
          width: 15.0.r,
        ),
      );
    }

    if (obscureText) {
      eye = StatefulBuilder(
        builder: (context, state) {
          return IconButton(
            splashRadius: 0.01,
            onPressed: () {
              state(() => obscureText = !obscureText);
              if (onChangeObscure != null) onChangeObscure!();
            },
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
          );
        },
      );
    }

    final border = OutlineInputBorder(
      borderSide: BorderSide(color: AppColorManager.cd),
      borderRadius: BorderRadius.circular(10.0.r),
    );

    final errorBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColorManager.red,
        width: 1.0.spMin,
      ),
      borderRadius: BorderRadius.circular(10.0.r),
    );

    final inputDecoration = InputDecoration(
      contentPadding: padding,
      errorBorder: errorBorder,
      border: border,
      focusedBorder: border,
      enabledBorder: border,
      helperText: widget.helperText,
      helperStyle: const TextStyle(color: Colors.grey),
      fillColor: AppColorManager.f9,
      label: DrawableText(
        text: widget.label,
        color: AppColorManager.grey,
        size: 16.0.spMin,
      ),
      counter: const SizedBox(),
      hintText: widget.hint,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintTextDirection: widget.textDirection,
      hintStyle: TextStyle(
        color: AppColorManager.grey,
        fontSize: widget.enable == false ? 10.0.sp : 14.0.sp,
      ),
      filled: false,

      prefixIcon: widget.iconWidget ?? suffixIcon,
      suffixIcon: widget.iconWidgetLift ?? eye,
    );

    final textStyle = TextStyle(
      fontSize: 16.0.spMin,
    );

    return StatefulBuilder(
      builder: (context, state) {
        onChangeObscure = () => state(() {});
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawableText(
              text: widget.label,
              padding: const EdgeInsets.symmetric(horizontal: 3.0).w,
              color: AppColorManager.white,
              size: 14.0.sp,
              drawableEnd: widget.required
                  ? DrawableText(
                      text: '*',
                      size: 18.0.sp,
                      color: Colors.red,
                    )
                  : null,
            ),
            3.0.verticalSpace,
            Directionality(
              textDirection: TextDirection.ltr,
              child: IntlPhoneField(
                onTap: () => widget.onTap?.call(),
                validator: widget.validator,
                decoration: inputDecoration,
                dropdownTextStyle: TextStyle(color: Colors.white),
                initialCountryCode: 'IQ',
                dropdownIcon: Icon(Icons.arrow_drop_down, color: Colors.white),
                cursorColor: Colors.white,
                readOnly: !(widget.enable ?? true),
                initialValue: widget.initialValue,
                obscureText: obscureText,
                textAlign: widget.textAlign,
                onChanged: widget.onChanged,
                style: textStyle,
                focusNode: focusNode,
                controller: widget.controller,
              ),
            ),
          ],
        );
      },
    );
  }
}
*/

class IntInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    // Only allow digits
    final filteredText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    return TextEditingValue(
      text: filteredText,
      selection: TextSelection.collapsed(offset: filteredText.length),
    );
  }
}
