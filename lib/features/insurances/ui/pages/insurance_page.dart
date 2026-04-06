import 'dart:convert';

import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/app/app_provider.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/helper/launcher_helper.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/util/my_style.dart';
import 'package:al_andalus/core/widgets/card_slider_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../core/util/bottom_sheets.dart';
import '../../../../core/widgets/app_bar/app_bar_widget.dart';
import '../../../../core/widgets/refresh_widget/refresh_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../router/go_router.dart';
import '../../bloc/insurance_cubit/insurance_cubit.dart';
import '../../bloc/insurances_cubit/insurances_cubit.dart';
import '../../data/response/insurance_package.dart';

class InsurancePage extends StatelessWidget {
  const InsurancePage({
    super.key,
    required this.id,
    required this.estimatedPrice,
    required this.cylindersCount,
  });

  final String id;
  final double estimatedPrice;
  final int cylindersCount;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InsurancesCubit, InsurancesInitial>(
      builder: (context, state) {
        final list = state.result.where((e) => e.type == .private).toList()
          ..sort((a, b) => a.level.index.compareTo(b.level.index));
        return Scaffold(
          appBar: AppBarWidget(
            titleText: S.of(context).insurance,
            actions: [
              20.0.horizontalSpace,
              InkWell(
                onTap: () => showSupportCall(context),
                child: ImageMultiType(
                  url: context.isDark ? Assets.iconsSupportBorder : Assets.iconsSupportBorder1,
                  height: 40.0.r,
                  width: 40.0.r,
                ),
              ),
              20.0.horizontalSpace,
            ],
          ),
          body: CardSlider1(
            onPageCh: (i, reason) {},
            autoPlay: false,
            viewportFraction: 0.75,
            height: 1.0.sh,
            initialPage: list.indexWhere((element) => element.level == .gold),
            images: list.map(
              (insurance) {
                insurance
                  ..estimatedPrice = estimatedPrice
                  ..cylindersCount = cylindersCount;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0).r,
                  child: Column(
                    children: [
                      Expanded(child: _Item(item: insurance)),
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(vertical: 20.0),
                        child: OutLineButton(
                          onTap: () {
                            if (AppProvider.needLogin) {
                              AppProvider.insurancePage = {
                                'id': insurance.id.toString(),
                                'price': insurance.estimatedPrice.toString(),
                                'cylindersCount': insurance.cylinder.cylinders.toString(),
                              };
                              return;
                            }

                            context.pushNamed(
                              RouteName.addCarPage,
                              queryParameters: {
                                'id': insurance.id.toString(),
                                'price': insurance.price.toString(),
                                'cylindersCount': insurance.cylinder.cylinders,
                              },
                            );
                          },
                          text: S.of(context).subscribeNow,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({super.key, required this.item});

  final InsurancePackage item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Top(item: item),
        2.0.verticalSpace,
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColorManager.cardColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.0).r),
              boxShadow: MyStyle.allShadow,
            ),
            child: Column(
              children:
                  item.features.map((feature) {
                    return ListTile(
                          leading: ImageMultiType(
                            url: Assets.iconsDoneStep,
                            height: 20.0.r,
                            width: 20.0.r,
                          ),
                          title: DrawableText(text: feature.title),
                        )
                        as Widget;
                  }).toList()..addAll(
                    [
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          context.pushNamed(
                            RouteName.pdf,
                            queryParameters: {
                              'url': item.descriptionFile,
                              'title': S.of(context).packageDetails,
                            },
                          );
                        },
                        child: DrawableText(
                          text: S.of(context).knowMoreDetails,
                          textDecoration: .underline,
                        ),
                      ),
                      20.0.verticalSpace,
                    ],
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Top extends StatelessWidget {
  const _Top({super.key, required this.item});

  final InsurancePackage item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0.h,
      clipBehavior: .hardEdge,
      width: 1.0.sw,
      decoration: BoxDecoration(
        color: AppColorManager.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0).r),
        boxShadow: MyStyle.allShadow,
      ),
      child: Stack(
        children: [
          ImageMultiType(
            height: 1.0.sh,
            width: 1.0.sw,
            url: Assets.iconsTopCard,
            color: item.level.color,
            fit: .fill,
          ),
          Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Container(
                  padding: const EdgeInsets.all(4.0).r,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24.0).r,
                      bottomLeft: Radius.circular(24.0).r,
                    ),
                  ),
                  child: DrawableText(
                    text: item.title,
                    color: Colors.white,
                    size: 20.0.sp,
                  ),
                ),
                20.0.verticalSpace,
                DrawableText(
                  text: item.price.formatPrice,
                  color: Colors.white,
                  size: 32.0.sp,
                  drawableEnd: DrawableText(
                    text: '/${S.of(context).annually}',
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                DrawableText(
                  text: S.of(context).features,

                  size: 18.0.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
