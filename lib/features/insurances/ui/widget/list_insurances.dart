import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/widgets/card_slider_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/insurances_cubit/insurances_cubit.dart';
import 'item_insurance.dart';

class ListInsurances extends StatelessWidget {
  const ListInsurances({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InsurancesCubit, InsurancesInitial>(
      builder: (context, state) {
        return _CardSlider(
          images: state.result.map((e) => ItemInsurance(insurance: e)).toList(),
          height: 0.4.sh,
          autoPlay: false,
          viewportFraction: 0.7,
        );

      },
    );
  }
}

class _CardSlider extends StatelessWidget {
  const _CardSlider({
    super.key,
    this.margin,
    required this.images,
    this.height,
    this.width,
    this.viewportFraction,
    this.seconds,
    this.initialPage,
    this.autoPlay,
  });

  final EdgeInsets? margin;
  final List<Widget> images;
  final double? height;
  final double? viewportFraction;
  final double? width;
  final int? seconds;
  final int? initialPage;
  final bool? autoPlay;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: images,

      options: CarouselOptions(
        autoPlayInterval: Duration(seconds: seconds ?? 6),
        autoPlay: autoPlay ?? true,
        initialPage: initialPage ?? 0,
        // disableCenter: true,
        viewportFraction: viewportFraction ?? 1,
        height: height,
        enlargeCenterPage: true,
        pauseAutoPlayInFiniteScroll: false,
        disableCenter: true,
        enableInfiniteScroll: true,
        animateToClosest: true,
        pageSnapping: true,
        pauseAutoPlayOnTouch: true,
        pauseAutoPlayOnManualNavigate: true,
        padEnds: true,

        onPageChanged: (i, reason) {
          // key.currentState?.changePage(i);
        },
      ),
    );
    // return Column(
    //   children: [
    //     IndicatorSliderWidget(key: key, length: images.length),
    //   ],
    // );
  }
}
