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

import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/bottom_sheets.dart';
import '../../../../core/widgets/app_bar/app_bar_widget.dart';
import '../../../../core/widgets/refresh_widget/refresh_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../router/go_router.dart';
import '../../bloc/insurance_cubit/insurance_cubit.dart';
import '../../bloc/insurances_cubit/insurances_cubit.dart';
import '../../data/response/insurance_package.dart';

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

import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/bottom_sheets.dart';
import '../../../../core/widgets/app_bar/app_bar_widget.dart';
import '../../../../core/widgets/refresh_widget/refresh_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../router/go_router.dart';
import '../../bloc/insurance_cubit/insurance_cubit.dart';
import '../../bloc/insurances_cubit/insurances_cubit.dart';
import '../../data/response/insurance_package.dart';

class InsurancePage extends StatefulWidget {
  const InsurancePage({
    super.key,
    required this.id,
    required this.estimatedPrice,
    required this.cylindersCount,
    required this.type,
  });

  final String id;
  final double estimatedPrice;
  final int cylindersCount;
  final InsuranceType type;

  @override
  State<InsurancePage> createState() => _InsurancePageState();
}

class _InsurancePageState extends State<InsurancePage> {
  late InsuranceType type;

  @override
  void initState() {
    super.initState();
    type = widget.type;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InsurancesCubit, InsurancesInitial>(
      builder: (context, state) {
        final list = state.result.where((e) => e.type == type).toList()
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
          body: Column(
            children: [
              20.0.verticalSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  spacing: 20.0.w,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => type = InsuranceType.private),
                        child: Container(
                          height: 40.0.h,
                          alignment: Alignment.center,
                          decoration: type == InsuranceType.private ? MyStyle.outlineBorder : MyStyle.roundBox12(),
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
                        onTap: () => setState(() => type = InsuranceType.public),
                        child: Container(
                          height: 40.0.h,
                          alignment: Alignment.center,
                          decoration: type == InsuranceType.public ? MyStyle.outlineBorder : MyStyle.roundBox12(),
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
              Expanded(
                child: CardSlider1(
                  onPageCh: (i, reason) {},
                  autoPlay: false,
                  viewportFraction: 0.75,
                  height: 1.0.sh,
                  initialPage: list.indexWhere((element) => element.level == InsuranceLevel.gold),
                  images: list.map(
                    (insurance) {
                      insurance
                        ..estimatedPrice = widget.estimatedPrice
                        ..cylindersCount = widget.cylindersCount;
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
              ),
            ],
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
            padding: EdgeInsets.all(15.0).r,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ...item.features.map((feature) {
                        return DrawableText(
                              text: feature.title,
                              matchParent: true,
                              padding: EdgeInsets.symmetric(vertical: 7.0),
                              drawableStart: ImageMultiType(
                                url: Assets.iconsDoneStep,
                                height: 20.0.r,
                                width: 20.0.r,
                              ),
                              drawablePadding: 10.0,
                            )
                            as Widget;
                      }).toList(),
                    ],
                  ),
                ),
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
                10.0.verticalSpace,
              ],
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
      height: 215.0.h,
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
            padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 15.0).r,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
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
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0).r,
                        size: 20.0.sp,
                      ),
                    ),
                    Spacer(),
                    item.type.icon,
                  ],
                ),
                10.0.verticalSpace,
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
