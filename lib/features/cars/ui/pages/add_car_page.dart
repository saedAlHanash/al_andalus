import 'package:al_andalus/core/util/snack_bar_message.dart';
import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/features/auth/ui/widget/custom_stepper_widget.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/shimmer_widget.dart';
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

  void _onBack(CarsInitial state) {
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
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CarsCubit, CarsInitial>(
          listenWhen: (p, c) => c.done && c.url.isNotEmpty,
          listener: (context, state) {
            context.pushNamed(RouteName.webView, queryParameters: {'url': state.url}).then(
              (value) {
                if (context.mounted) {
                  context.pushNamed(
                    RouteName.paymentSuccess,
                    extra: state.mRequest,
                    queryParameters: {
                      'isSuccessPayment': (value == true).toString(),
                      'isRepay': 'false',
                    },
                  );
                }
              },
            );
            context.read<CarsCubit>().doneOpenUrl();
          },
        ),
        BlocListener<CarsCubit, CarsInitial>(
          listenWhen: (p, c) => c.done && c.update,
          listener: (context, state) {
            context.pop(true);
          },
        ),
      ],
      child: BlocBuilder<CarsCubit, CarsInitial>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBarWidget(
              titleText: S.of(context).addNewCar,
              canPop: false,
              onPopInvoked: (b, result) {
                if (b) return;
                _onBack(state);
              },
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsetsGeometry.all(20.0),
              child: Column(
                spacing: 5.0,
                mainAxisSize: .min,
                children: [
                  MyButton(
                    loading: state.loading,
                    onTap: () {
                      final request = state.mRequest;

                      if (state.mRequest.id != null && state.step >= 3) {
                        context.read<CarsCubit>().update();
                        return;
                      }

                      if (state.step >= 4) {
                        context.read<CarsCubit>().create();
                        return;
                      }

                      if (!AddCarValidator.validateStep(context, state.step, request)) return;

                      context.read<CarsCubit>().next();
                    },
                    // loading: state.loading,
                    text: state.step == 4 ? S.of(context).pay : S.of(context).continueTo,
                  ),
                  if ((state.create || state.update) && state.loading)
                    ShimmerWidget(
                      child: DrawableText(
                        textAlign: TextAlign.center,
                        text: 'يتم الآن تحميل الملفات: ${(state.uploadProgress * 100).toInt()}%',
                      ),
                    ),
                ],
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
                      if (state.mRequest.id == null)
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
          );
        },
      ),
    );
  }
}
