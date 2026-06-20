import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/util/bottom_sheets.dart';
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
import '../../../../core/util/snack_bar_message.dart';
import '../widget/create_accident_steps/accident_images.dart';
import '../widget/create_accident_steps/accident_info.dart';
import '../widget/create_accident_steps/add_accident_validator.dart';

class AddAccidentPage extends StatefulWidget {
  const AddAccidentPage({super.key});

  @override
  State<AddAccidentPage> createState() => _AddAccidentPageState();
}

class _AddAccidentPageState extends State<AddAccidentPage> {
  void _onBack(AccidentsInitial state) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (state.step > 0) {
      context.read<AccidentsCubit>().next(step: state.step - 1);
    } else {
      NoteMessage.showCheckDialog(
        context,
        text: S.of(context).exitAddAccidentConfirmation,
        textButton: S.of(context).yes,
        onConfirm: (confirm) {
          loggerObject.w(confirm);
          if (confirm) {
            FocusManager.instance.primaryFocus?.unfocus();
            context.pop();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccidentsCubit, AccidentsInitial>(
      listenWhen: (p, c) => c.done,
      listener: (context, state) {
        FocusManager.instance.primaryFocus?.unfocus();
        showAccidentReportedBottomSheet(
          context,
          onClosed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            context.pop();
          },
        );
      },
      child: BlocBuilder<AccidentsCubit, AccidentsInitial>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBarWidget(
              titleText: S.of(context).reportAccident,
              canPop: false,
              onPopInvoked: (b, result) {
                if (b) return;
                _onBack(state);
              },
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsetsGeometry.all(20.0),
              child: MyButton(
                loading: state.loading,
                onTap: () {
                  final request = state.mRequest;

                  if (!AddAccidentValidator.validateStep(context, state.step, request)) return;

                  FocusManager.instance.primaryFocus?.unfocus();

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
                      FocusManager.instance.primaryFocus?.unfocus();
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
