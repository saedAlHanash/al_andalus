import 'package:al_andalus/features/ads/ui/widgets/adds_slider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../category/ui/widget/home_categories.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0).r,
        children: [
          AddsSlider(type: AdsType.banner, height: 150.0),
          20.0.verticalSpace,
          HomeCategories(),
          24.0.verticalSpace,
          AddsSlider(type: AdsType.slider, height: 140.0.h),

        ],
      ),
    );
  }
}
