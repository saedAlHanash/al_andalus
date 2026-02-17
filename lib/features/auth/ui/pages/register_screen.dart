//
// import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../../generated/l10n.dart';
//
// class RegisterScreen extends StatelessWidget {
//   const RegisterScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarWidget(
//
//         titleText: S.of(context).createAccount,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20.0).r,
//         child: BlocBuilder<RegisterCubit, RegisterState>(
//           builder: (context, state) {
//             return Column(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: (AppPadding.defaultPadding / 2).w),
//                   child: CustomStepperWidget(
//                     activeStep: state.activeStep,
//                     onStepReached: (index) => context.read<RegisterCubit>().updateCurrentActiveStep(index),
//                     steps: [
//                       customStepWidget(
//                         context: context,
//                         title: LocaleKeys.single_certificate,
//                         isCompleted: state.activeStep > 0,
//                       ),
//                       customStepWidget(
//                         context: context,
//                         title: LocaleKeys.single_certificate_description,
//                         isCompleted: state.activeStep > 1,
//                         isSelected: state.isSelected(1),
//                       ),
//                       customStepWidget(
//                         context: context,
//                         title: LocaleKeys.phone_number,
//                         isCompleted: state.activeStep > 2,
//                         isSelected: state.isSelected(2),
//                       ),
//                       customStepWidget(
//                         context: context,
//                         title: LocaleKeys.otp,
//                         isCompleted: state.activeStep > 3,
//                         isSelected: state.isSelected(3),
//                       ),
//                     ],
//                   ),
//                 ),
//                 24.verticalSpace,
//                 Expanded(child: _currentWidget(state.activeStep)),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _currentWidget(int value) {
//     if (value == 0) {
//       return const RegisterStep1();
//     } else if (value == 1) {
//       return const RegisterStep2();
//     } else if (value == 2) {
//       return const RegisterStep3();
//     }
//     return const RegisterStep4();
//   }
// }
