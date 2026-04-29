import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/util/my_style.dart';
import 'package:al_andalus/core/util/my_style.dart';
import 'package:al_andalus/core/widgets/card_slider_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/bottom_sheets.dart';
import '../../../../router/go_router.dart';
import '../../bloc/insurances_cubit/insurances_cubit.dart';
import '../../data/response/insurance_package.dart';
import 'item_insurance.dart';

class ListInsurances extends StatefulWidget {
  const ListInsurances({super.key, this.onTapInfo});

  final Function(InsurancePackage e)? onTapInfo;

  @override
  State<ListInsurances> createState() => _ListInsurancesState();
}

class _ListInsurancesState extends State<ListInsurances> {
  var type = InsuranceType.private;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InsurancesCubit, InsurancesInitial>(
      builder: (context, state) {
        final list = state.result.where((e) => e.type == type).toList();
        return Column(
          children: [
            20.0.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                spacing: 20.0.w,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => type = .private),
                      child: Container(
                        height: 40.0.h,
                        alignment: .center,
                        decoration: type == .private ? MyStyle.outlineBorder : MyStyle.roundBox12(),
                        child: DrawableText(text: InsuranceType.private.name),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => type = .public),
                      child: Container(
                        height: 40.0.h,
                        alignment: .center,
                        decoration: type == .public ? MyStyle.outlineBorder : MyStyle.roundBox12(),
                        child: DrawableText(text: InsuranceType.public.name),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            20.0.verticalSpace,
            _CardSlider(
              images: list
                  .map(
                    (e) => ItemInsurance(
                      insurance: e,
                      onTapInfo: () {
                        widget.onTapInfo?.call(e);
                        if (widget.onTapInfo == null) {
                          showCalculationPrice(
                            context,
                            e,
                            (queryParameters) {
                              context.pushNamed(
                                RouteName.insurancePage,
                                queryParameters: queryParameters..addAll({'type': type.index}),
                              );
                            },
                          );
                        }
                      },
                    ),
                  )
                  .toList(),
              height: 160.0.h + (state.getMaxFeaturesCount * 12),
              autoPlay: false,
              viewportFraction: 0.7,
            ),
            20.0.verticalSpace,
          ],
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
