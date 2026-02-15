import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../data/response/category_response.dart';

class ItemCategory extends StatelessWidget {
  const ItemCategory({super.key, required this.category, required this.onTap, this.selected = false});

  final Category category;
  final bool selected;
  final Function(Category category) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap.call(category),
      child: SizedBox(
        height: 90.0.dg,
        width: 90.0.w,
        child: Column(
          mainAxisSize: .min,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColorManager.cardColor,
                  border: selected
                      ? Border.all(
                          color: AppColorManager.mainColor,
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(12.0).r,
                ),
                clipBehavior: Clip.hardEdge,

                child: Center(
                  child: ImageMultiType(
                    url: category.image,
                    width: 90.0.w,
                    height: 90.0.w,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            DrawableText(
              text: category.name,
              padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0).r,
              textAlign: TextAlign.center,
              maxLines: 1,

              size: category.name.length > 12 ? 10.0.sp : 11.0.sp,
            ),
          ],
        ),
      ),
    );
  }
}
