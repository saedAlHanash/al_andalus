import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'item_expansion.dart';

class MyExpansionWidget extends StatefulWidget {
  const MyExpansionWidget({
    super.key,
    required this.items,
    this.onTapItem,
    this.elevation,
    this.onExpansion,
    this.decoration,
  });

  final List<ItemExpansion> items;
  final double? elevation;
  final BoxDecoration? decoration;
  final Function(int, bool)? onTapItem;
  final Function(int panelIndex, bool isExpanded)? onExpansion;

  @override
  State<MyExpansionWidget> createState() => _MyExpansionWidgetState();
}

class _MyExpansionWidgetState extends State<MyExpansionWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final e = widget.items[index];
        final isExpanded = e.isExpanded;

        Widget headerContent;
        if (e.header != null) {
          headerContent = e.header!;
        } else {
          headerContent = DrawableText(
            text: e.headerText ?? '',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColorManager.black,
            ),
          );
        }

        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.0.h),
          decoration: ShapeDecoration(
            color: AppColorManager.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0.r),
              side: BorderSide(color: AppColorManager.cd, width: 0.5.r),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x0A212121),
                blurRadius: 3.65,
                offset: Offset(0, 2.44),
              ),
              BoxShadow(
                color: Color(0x14212121),
                blurRadius: 30.45,
                offset: Offset(0, 2.44),
              ),
            ],
          ),
          child: Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10.0.r),
                  bottom: Radius.circular(isExpanded ? 0 : 10.0.r),
                ),
                onTap: e.enable
                    ? () {
                        widget.onExpansion?.call(index, !isExpanded);
                        setState(() {
                          e.isExpanded = !isExpanded;
                        });
                      }
                    : null,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_left,
                        color: AppColorManager.mainColor,
                        size: 24.r,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: headerContent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity),
                secondChild: e.body,
                crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
                firstCurve: Curves.easeInOut,
                secondCurve: Curves.easeInOut,
              ),
            ],
          ),
        );
      },
    );
  }
}
