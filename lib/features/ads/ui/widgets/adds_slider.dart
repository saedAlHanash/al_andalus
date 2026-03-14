import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/widgets/card_slider_widget.dart';
import 'package:al_andalus/features/ads/bloc/adss_cubit/adss_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/my_style.dart';

class AddsSlider extends StatelessWidget {
  const AddsSlider({super.key, required this.type, this.height});

  final AdsType type;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdssCubit, AdssInitial>(
      builder: (context, state) {
        final list = state.result.where((e) => e.type.index == type.index);
        if (list.isEmpty) return 0.0.verticalSpace;
        if (state.loading) {
          return MyStyle.loadingWidget();
        }
        return CardSlider(
          height: height,
          images: list.map((e) => e.image),
          stackChild: [
            // IgnorePointer(
            //   child: Align(
            //     alignment: .bottomCenter,
            //     child: Container(
            //       width: 1.0.sw,
            //       height: height ?? 0 / 2,
            //       decoration: BoxDecoration(
            //         gradient: LinearGradient(
            //           colors: [
            //             Colors.transparent,
            //             Colors.black12,
            //             Colors.black38,
            //           ],
            //           begin: .topCenter,
            //           end: .bottomCenter,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        );
      },
    );
  }
}

// class BannersSlider extends StatelessWidget {
//   const BannersSlider({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<BannersCubit, BannersInitial>(
//       builder: (context, state) {
//         if (state.loading) {
//           return MyStyle.loadingWidget();
//         }
//         return Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12.0.r),
//           ),
//           clipBehavior: Clip.hardEdge,
//           child: CardSlider(
//             images: state.result.map((e) => e.image),
//           ),
//         );
//       },
//     );
//   }
// }
