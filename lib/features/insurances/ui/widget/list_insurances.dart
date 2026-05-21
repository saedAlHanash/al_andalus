import 'package:al_andalus/core/util/my_style.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
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
        final list = state.result.where((e) => e.type == type).sortedBy((e) => e.level.index);

        if (list.isEmpty) return 0.0.verticalSpace;
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
                        child: DrawableText(
                          text: InsuranceType.private.name,
                          drawableStart: InsuranceType.private.icon,
                          drawablePadding: 5.0,
                        ),
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
                        child: DrawableText(
                          text: InsuranceType.public.name,
                          drawableStart: InsuranceType.public.icon,
                          drawablePadding: 5.0,
                        ),
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
                              final q = queryParameters..addAll({'type': type.index.toString()});
                              context.pushNamed(
                                RouteName.insurancePage,
                                queryParameters: q,
                              );
                            },
                          );
                        }
                      },
                    ),
                  )
                  .toList(),
              height: 160.0.h + (state.getMaxFeaturesCount * 12),
              viewportFraction: 0.7,
            ),
            20.0.verticalSpace,
          ],
        );
      },
    );
  }
}

class _CardSlider extends StatefulWidget {
  const _CardSlider({
    required this.images,
    this.height,
    this.viewportFraction,
  });

  final List<Widget> images;
  final double? height;
  final double? viewportFraction;

  @override
  State<_CardSlider> createState() => _CardSliderState();
}

class _CardSliderState extends State<_CardSlider> {
  final _controller = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.images.isNotEmpty) {
        _controller.jumpToPage(widget.images.length ~/ 2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      carouselController: _controller,
      items: widget.images,
      options: CarouselOptions(
        viewportFraction: widget.viewportFraction ?? 1,
        height: widget.height,
        enlargeCenterPage: true,
        disableCenter: true,
        enableInfiniteScroll: false,
        onPageChanged: (i, reason) {
          // key.currentState?.changePage(i);
        },
      ),
    );
  }
}
