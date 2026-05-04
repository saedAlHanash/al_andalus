import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/l10n.dart';
import 'custom_stepper_widget.dart';

class SliderSignup extends StatelessWidget {
  const SliderSignup({super.key, required this.step, this.onStepReached});

  final int step ;  final void Function(int)? onStepReached;
  @override
  Widget build(BuildContext context) {
    return     Padding(
      padding: EdgeInsets.symmetric(horizontal: 37.0).r,
      child: CustomStepperWidget(
        activeStep: step,
        onStepReached: onStepReached,
        steps: [
          customStepWidget(
            title: S.of(context).unified,
            isCompleted: step > 0,
            isSelected: step == 0,
          ),
          customStepWidget(
            title: S.of(context).drivingLicense,
            isCompleted: step > 1,
            isSelected: step == 1,
          ),
          customStepWidget(
            title: S.of(context).phoneNumber,
            isCompleted: step > 2,
            isSelected: step == 2,
          ),
          customStepWidget(
            title: S.of(context).verificationCode,
            isCompleted: step > 3,
            isSelected: step == 3,
          ),
          customStepWidget(
            title: S.of(context).pinCode,
            isCompleted: step > 4,
            isSelected: step == 4,
          ),
        ],
      ),
    );
  }
}
