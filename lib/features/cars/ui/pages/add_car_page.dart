import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/helper/launcher_helper.dart';
import 'package:al_andalus/core/util/snack_bar_message.dart';
import 'package:flutter/material.dart';
import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/features/auth/ui/widget/custom_stepper_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';
import '../../../../router/go_router.dart';
import '../../bloc/cars_cubit/cars_cubit.dart';
import '../widget/create_car_steps/add_car_validator.dart';
import '../widget/create_car_steps/annual_info.dart';
import '../widget/create_car_steps/car_images.dart';
import '../widget/create_car_steps/car_inspection.dart';
import '../widget/create_car_steps/car_preview.dart';
import '../widget/create_car_steps/payment_screen.dart';

class AddCarPage extends StatefulWidget {
  const AddCarPage({super.key});

  @override
  State<AddCarPage> createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  CarsCubit get carsCubit => context.read<CarsCubit>();

  CarsInitial get carsState => context.read<CarsCubit>().state;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CarsCubit, CarsInitial>(
      listenWhen: (p, c) => c.done && c.url.isNotEmpty,
      listener: (context, state) {
        context.pushNamed(RouteName.webView, queryParameters: {'url': state.url});
        context.read<CarsCubit>().doneOpenUrl();
      },
      child: BlocBuilder<CarsCubit, CarsInitial>(
        builder: (context, state) {
          return PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              if (didPop) return;
              if (state.step > 0) {
                context.read<CarsCubit>().next(step: state.step - 1);
              } else {
                NoteMessage.showCheckDialog(
                  context,
                  text: S.of(context).exitAddCarConfirmation,
                  textButton: S.of(context).yes,
                  onConfirm: (confirm) {
                    if (confirm) context.pop();
                  },
                );
              }
            },
            child: Scaffold(
              appBar: AppBarWidget(titleText: S.of(context).signUp),
              bottomNavigationBar: Padding(
                padding: EdgeInsetsGeometry.all(20.0),
                child: MyButton(
                  loading: state.loading,
                  onTap: () {
                    final request = state.mRequest;

                    if (state.step >= 4) {
                      LauncherHelper.openPage('https://test.zaincash.iq/transaction/pay?id=69a359524758590b12651394');
                      // context.read<CarsCubit>().create();
                      return;
                    }

                    if (!AddCarValidator.validateStep(context, state.step, request)) return;

                    context.read<CarsCubit>().next();
                  },
                  // loading: state.loading,
                  text: state.step == 4 ? S.of(context).pay : S.of(context).continueTo,
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
                            if (!AddCarValidator.validateStep(context, i, request)) return;
                          }
                        }
                        context.read<CarsCubit>().next(step: p0);
                      },
                      steps: [
                        customStepWidget(
                          title: S.of(context).inspection,
                          isCompleted: state.step > 0,
                          isSelected: state.step == 0,
                        ),
                        customStepWidget(
                          title: S.of(context).annual,
                          isCompleted: state.step > 1,
                          isSelected: state.step == 1,
                        ),
                        customStepWidget(
                          title: S.of(context).preview,
                          isCompleted: state.step > 2,
                          isSelected: state.step == 2,
                        ),
                        customStepWidget(
                          title: S.of(context).carImages,
                          isCompleted: state.step > 3,
                          isSelected: state.step == 3,
                        ),
                        customStepWidget(
                          title: S.of(context).payment,
                          isCompleted: state.step > 4,
                          isSelected: state.step == 4,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: switch (state.step) {
                      0 => CarInspection(),
                      1 => AnnualInfo(),
                      2 => CarPreview(),
                      3 => CarInspectionScreen(),
                      4 => PaymentScreen(),
                      int() => SizedBox(),
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
