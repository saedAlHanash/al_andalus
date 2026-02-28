import 'package:al_andalus/core/widgets/refresh_widget/refresh_widget.dart';
import 'package:al_andalus/features/ads/bloc/adss_cubit/adss_cubit.dart';
import 'package:al_andalus/features/ads/ui/widgets/adds_slider.dart';
import 'package:al_andalus/features/home/ui/widget/hi_widget.dart';
import 'package:al_andalus/features/home/ui/widget/how_can_help.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../category/ui/widget/home_categories.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            AddsSlider(type: AdsType.banner, height: 150.0),
            HowCanHelp(),
            AddsSlider(type: AdsType.slider, height: 90.0),
          ],
        ),
      ),
    );
  }
}
