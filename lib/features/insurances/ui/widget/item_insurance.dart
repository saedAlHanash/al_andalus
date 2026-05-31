import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/util/my_style.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../router/go_router.dart';
import '../../data/response/insurance_package.dart';
import 'package:collection/collection.dart';


class ItemInsurance extends StatelessWidget {
  const ItemInsurance({
    super.key,
    required this.insurance,
    this.onTapInfo,
    this.isDetail = false,
  });

  final InsurancePackage insurance;
  final Function()? onTapInfo;
  final bool isDetail;

  @override
  Widget build(BuildContext context) {
    if (isDetail) return _DetailItem(item: insurance);

    final tagText = insurance.tag.isEmpty ? insurance.level.name : insurance.tag;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            insurance.level.color,
            insurance.level.color.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(24.0.r),
      ),
      padding: EdgeInsets.only(top: 4.0, right: 4, left: 4, bottom: 4).r,
      child: Column(
        children: [
          DrawableText(
            text: tagText,
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 5.0),
            fontWeight: FontWeight.bold,
            size: 14.sp,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9FB),
                borderRadius: BorderRadius.circular(20.0.r),
                border: Border.all(color: AppColorManager.cd),
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
                    decoration: BoxDecoration(
                      color: AppColorManager.cardColor,
                      borderRadius: BorderRadius.circular(20.0.r),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10.r,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DrawableText(
                          text: insurance.title,
                          size: 20.sp,
                          drawableStart: insurance.type.icon,
                          drawablePadding: 5.0,
                          matchParent: true,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.start,
                        ),
                        10.verticalSpace,
                        DrawableText(
                          text: insurance.brief,
                          color: Colors.grey.shade600,
                          size: 14.sp,
                          textAlign: TextAlign.center,
                        ),
                        20.verticalSpace,
                        MyButton(
                          onTap: () => onTapInfo?.call(),
                          height: 35.0.h,
                          text: S.of(context).knowMore,
                          color: insurance.level.color,
                        ),
                      ],
                    ),
                  ),
                  10.0.verticalSpace,
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: insurance.features.map((feature) {
                          return DrawableText(
                            text: feature.title,
                            matchParent: true,
                            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                            drawableStart: ImageMultiType(
                              url: Assets.iconsDoneStep,
                              height: 20.0.r,
                              width: 20.0.r,
                            ),
                            drawablePadding: 5.0,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatefulWidget {
  const _DetailItem({required this.item});

  final InsurancePackage item;

  @override
  State<_DetailItem> createState() => _DetailItemState();
}

class _DetailItemState extends State<_DetailItem> {
   var _showedHint = false;
  var _showScrollHint = false;

  @override
  void initState() {
    super.initState();
    if (!_showedHint) {
      _showScrollHint = true;
      _showedHint = true;
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) setState(() => _showScrollHint = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Top(item: widget.item),
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
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          ...widget.item.features.map((feature) {
                            return DrawableText(
                              text: feature.title,
                              matchParent: true,
                              padding: const EdgeInsets.symmetric(vertical: 7.0),
                              drawableStart: ImageMultiType(
                                url: Assets.iconsDoneStep,
                                height: 20.0.r,
                                width: 20.0.r,
                              ),
                              drawablePadding: 10.0,
                            );
                          }).toList(),
                        ],
                      ),
                      if (_showScrollHint)
                        Align(
                          alignment: .center,
                          child: IgnorePointer(
                            child: Lottie.asset(
                              Assets.lottiesAnimatedMoveUpwardsLinearIconFixed2,
                              height: 120.0.r,
                              decoder: customDecoder,
                              // delegates: LottieDelegates(
                              //   values: [
                              //     ValueDelegate.colorFilter(
                              //       ['**'], // هنا الـ ** ستجبر الفلتر يغطي كل الطبقات غصب عنها
                              //       value: ColorFilter.mode(
                              //         AppColorManager.textColor,
                              //         BlendMode.srcIn,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.pushNamed(
                      RouteName.media,
                      queryParameters: {
                        'url': widget.item.descriptionFile,
                        'title': S.of(context).packageDetails,
                        'type': widget.item.mediaType.index.toString(),
                      },
                    );
                  },
                  child: DrawableText(
                    text: S.of(context).knowMoreDetails,
                    textDecoration: TextDecoration.underline,
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
  const _Top({required this.item});

  final InsurancePackage item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0.h,
      clipBehavior: Clip.hardEdge,
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
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
Future<LottieComposition?> customDecoder(List<int> bytes) {
  return LottieComposition.decodeZip(
    bytes,
    filePicker: (files) {
      return files.firstWhereOrNull(
            (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
      );
    },
  );
}