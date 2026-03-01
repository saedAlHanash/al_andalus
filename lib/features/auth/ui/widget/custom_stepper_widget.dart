import 'package:drawable_text/drawable_text.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../../../generated/assets.dart';

class CustomStepperWidget extends StatelessWidget {
  const CustomStepperWidget({super.key, required this.activeStep, this.onStepReached, required this.steps});

  final int activeStep;
  final void Function(int)? onStepReached;
  final List<EasyStep> steps;

  @override
  Widget build(BuildContext context) {
    return EasyStepper(
      showLoadingAnimation: false,
      activeStep: activeStep,
      onStepReached: onStepReached,
      disableScroll: true,
      defaultStepBorderType: BorderType.normal,
      activeStepBackgroundColor: AppColorManager.mainColor,
      unreachedStepTextColor: AppColorManager.grey,
      unreachedStepBorderColor: AppColorManager.grey,
      activeStepTextColor: AppColorManager.white,
      activeStepBorderColor: AppColorManager.mainColor,
      activeStepIconColor: AppColorManager.white,
      finishedStepBackgroundColor: AppColorManager.mainColor,
      finishedStepBorderColor: AppColorManager.mainColor,
      finishedStepIconColor: AppColorManager.white,
      finishedStepTextColor: AppColorManager.white,
      alignment: AlignmentDirectional.center,
      stepRadius: 11.r,
      finishedStepBorderType: BorderType.normal,
      lineStyle: LineStyle(
        lineLength: (0.4 - (steps.length - 2) * 0.066).sw,
        lineWidth: 120.w,
        lineThickness: 2.h,
        lineType: LineType.normal,
        unreachedLineType: LineType.normal,
        unreachedLineColor: AppColorManager.grey.withValues(alpha: .5),
        finishedLineColor: AppColorManager.mainColor,
        activeLineColor: AppColorManager.mainColor,
      ),
      steps: steps,
    );
  }
}

EasyStep customStepWidget({
  required String title,
  bool isSelected = false,
  bool isCompleted = false,
  Function? onTap,
}) {
  return EasyStep(
    customStep: ImageMultiType(
      url: isCompleted
          ? Assets.iconsDoneStep
          : isSelected
          ? Assets.iconsActiveStep
          : Assets.iconsStep,
    ),
    customTitle: DrawableText(
      text: title,
      size: 16.0.sp,
      textAlign: TextAlign.center,
      color: (isSelected || isCompleted) ? AppColorManager.mainColor : Colors.grey,
    ),
  );
}
