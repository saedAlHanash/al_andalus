import 'package:flutter/material.dart';
import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/features/auth/ui/widget/custom_stepper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';
import '../../../../router/go_router.dart';
import '../../bloc/cars_cubit/cars_cubit.dart';
import '../widget/create_car_steps/annual_info.dart';
import '../widget/create_car_steps/car_images.dart';
import '../widget/create_car_steps/car_inspection.dart';
import '../widget/create_car_steps/car_preview.dart';

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
      listenWhen: (p, c) => c.done,
      listener: (context, state) {
        context.goNamed(RouteName.confirmCode);
      },
      child: BlocBuilder<CarsCubit, CarsInitial>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBarWidget(titleText: S.of(context).signUp),
            bottomNavigationBar: Padding(
              padding: EdgeInsetsGeometry.all(20.0),
              child: MyButton(
                onTap: () {
                  final request = state.mRequest;


                  if (state.step >= 3) {

                    return;
                  }
                  context.read<CarsCubit>().next();
                },
                loading: state.loading,
                text: S.of(context).continueTo,
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
                          // if (!CreateCarValidator.validateStep(context, i, request)) return;
                        }
                      }
                      context.read<CarsCubit>().next(step: p0);
                    },
                    steps: [
                      customStepWidget(
                        title: 'الفحص',
                        isCompleted: state.step > 0,
                        isSelected: state.step == 0,
                      ),
                      customStepWidget(
                        title: 'السنوية',
                        isCompleted: state.step > 1,
                        isSelected: state.step == 1,
                      ),
                      customStepWidget(
                        title: 'المعاينة',
                        isCompleted: state.step > 2,
                        isSelected: state.step == 2,
                      ),
                      customStepWidget(
                        title: 'صور المركبة',
                        isCompleted: state.step > 3,
                        isSelected: state.step == 3,
                      ),
                      customStepWidget(
                        title: 'الدفع',
                        isCompleted: state.step > 3,
                        isSelected: state.step == 3,
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
