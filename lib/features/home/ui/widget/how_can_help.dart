import 'dart:math';

import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/util/snack_bar_message.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../insurances/ui/widget/list_insurances.dart';

class HowCanHelp extends StatelessWidget {
  const HowCanHelp({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0).r,
      child: Row(
        spacing: 7.0.r,
        children: [
          Expanded(
            child: _Item(
              onTap: () {

              },
              height: 160.0,
              color: const Color(0x66F09D21),
              title: S.of(context).reportAccident,
              image: ImageMultiType(
                height: 120.0.r,
                width: 120.0.r,
                url: Assets.iconsAccident1,
              ),
            ),
          ),

          Expanded(
            child: SizedBox(
              height: 160.0,
              child: Column(
                spacing: 7.0.r,
                children: [
                  Expanded(
                    child: _Item(
                      onTap: () {},
                      color: const Color(0xFFE4E4E5),
                      title: S.of(context).transferOwnership,
                      image: ImageMultiType(
                        height: 70.0.r,
                        width: 70.0.r,
                        url: Assets.iconsTransport,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _Item(
                      onTap: () {
                        NoteMessage.showMyDialog(
                          context,
                          child: Column(
                            children: [
                              20.0.verticalSpace,
                              ListInsurances(),
                              20.0.verticalSpace,
                            ],
                          ),
                        );
                      },
                      color: const Color(0xFFFFEAD4),
                      title: S.of(context).addNewCar,
                      image: Transform.scale(
                        scale: 1.8,
                        child: ImageMultiType(
                          height: 40.0.r,
                          width: 50.0.r,
                          url: Assets.iconsNewCar,
                        ),
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

class _Item extends StatelessWidget {
  const _Item({
    super.key,
    required this.color,
    required this.title,
    required this.image,
    this.height,
    this.width,
    required this.onTap,
  });

  final Color color;
  final String title;
  final double? height;
  final double? width;
  final Function() onTap;

  final dynamic image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24.42),
        ),
        clipBehavior: .hardEdge,
        child: Stack(
          children: [
            Align(
              alignment: .topRight,
              child: DrawableText(
                matchParent: true,
                text: title,
                size: 16.0.sp,
                padding: EdgeInsets.all(20.0).r,
                fontWeight: FontWeight.w700,
              ),
            ),
            Align(
              alignment: .bottomLeft,
              child: image,
            ),
          ],
        ),
      ),
    );
  }
}
