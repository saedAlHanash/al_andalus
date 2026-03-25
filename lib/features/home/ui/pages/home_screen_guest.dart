import 'package:al_andalus/core/widgets/refresh_widget/refresh_widget.dart';
import 'package:al_andalus/features/ads/bloc/adss_cubit/adss_cubit.dart';
import 'package:al_andalus/features/ads/ui/widgets/adds_slider.dart';
import 'package:al_andalus/features/home/ui/widget/hi_widget.dart';
import 'package:al_andalus/features/home/ui/widget/how_can_help.dart';
import 'package:al_andalus/features/insurances/ui/widget/list_insurances.dart';
import 'package:drawable_text/drawable_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../category/ui/widget/home_categories.dart';

class GuestHomeScreen extends StatelessWidget {
  const GuestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshWidget(
        isLoading: false,
        onRefresh: () {
          context.read<AdssCubit>().getData(newData: true);
        },
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0).r,
          children: [
            HiWidget(),
            AddsSlider(type: AdsType.slider, height: 150.0),
            20.0.verticalSpace,
            DrawableText(
              text: S.of(context).firstCarInsurancePlatformInIraq,
              matchParent: true,
              textAlign: .center,
              fontWeight: .bold,
              size: 18.0.sp,
            ),
            DrawableText(
              text: S.of(context).insuranceIsEasierForBetterLife,
              matchParent: true,
              color: Colors.grey,
              textAlign: .center,
            ),

            20.0.verticalSpace,
            ListInsurances(),
            20.0.verticalSpace,
            AddsSlider(type: AdsType.banner, height: 90.0),
            150.0.verticalSpace,
          ],
        ),
      ),
    );
  }
}
