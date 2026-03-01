import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../core/widgets/app_bar/app_bar_widget.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/ui/widget/custom_stepper_widget.dart';
import '../../bloc/accidents_cubit/accidents_cubit.dart';
import '../widget/create_accident_steps/accident_images.dart';
import '../widget/create_accident_steps/accident_info.dart';
import '../widget/create_accident_steps/add_accident_validator.dart';

class AddAccidentPage extends StatefulWidget {
  const AddAccidentPage({super.key});

  @override
  State<AddAccidentPage> createState() => _AddAccidentPageState();
}

class _AddAccidentPageState extends State<AddAccidentPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AccidentsCubit, AccidentsInitial>(
      listenWhen: (p, c) => c.statuses == CubitStatuses.done,
      listener: (context, state) {
        context.pop(); // Go back when created
      },
      child: BlocBuilder<AccidentsCubit, AccidentsInitial>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBarWidget(titleText: S.of(context).reportAccident),
            bottomNavigationBar: Padding(
              padding: EdgeInsetsGeometry.all(20.0),
              child: MyButton(
                loading: state.statuses == CubitStatuses.loading,
                onTap: () {
                  final request = state.mRequest;

                  if (!AddAccidentValidator.validateStep(context, state.step, request)) return;

                  if (state.step >= 1) {
                    context.read<AccidentsCubit>().create();
                    return;
                  }

                  context.read<AccidentsCubit>().next();
                },
                text: state.step == 1 ? S.of(context).submit : S.of(context).continueTo,
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 37.0).r,
                  child: CustomStepperWidget(
                    activeStep: state.step,
                    onStepReached: (p0) {
                      final request = state.mRequest;
                      if (p0 > state.step) {
                        for (int i = state.step; i < p0; i++) {
                          if (!AddAccidentValidator.validateStep(context, i, request)) return;
                        }
                      }
                      context.read<AccidentsCubit>().next(step: p0);
                    },
                    steps: [
                      customStepWidget(
                        title: S.of(context).generalInformation,
                        isCompleted: state.step > 0,
                        isSelected: state.step == 0,
                      ),
                      customStepWidget(
                        title: S.of(context).photosOfTheAccident,
                        isCompleted: state.step > 1,
                        isSelected: state.step == 1,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: switch (state.step) {
                    0 => AccidentInfo(),
                    1 => AccidentImages(),
                    int() => SizedBox(),
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
