import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/util/bottom_sheets.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../../generated/assets.dart';
import '../../../../../generated/l10n.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../data/generic_car_internal_option.dart';

class GenericCarExternalWidget extends StatefulWidget {
  const GenericCarExternalWidget({
    super.key,
    required this.title,
    required this.options,
  });

  final String title;
  final List<GenericCarInternalOption> options;

  @override
  State<GenericCarExternalWidget> createState() => _GenericCarExternalWidgetState();
}

class _GenericCarExternalWidgetState extends State<GenericCarExternalWidget> {
  bool isOpen = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        border: Border.all(color: AppColorManager.cd),
        borderRadius: BorderRadius.circular(12.0).r,
      ),
      padding: EdgeInsets.all(15.0).r,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => isOpen = !isOpen),
            child: DrawableText(
              text: widget.title,
              size: 18.0.sp,
              matchParent: true,
              padding: EdgeInsets.symmetric(vertical: 10.0).h,
              drawableEnd: AnimatedRotation(
                turns: isOpen ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: ImageMultiType(url: Assets.icons.arrpwDowne.path),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1.0,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: !isOpen
                ? const SizedBox.shrink()
                : Column(
                    key: const ValueKey('expanded_content'),
                    children: [
                      const Divider(height: 0),
                      20.0.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          100.0.horizontalSpace,
                          ...List.generate(
                            CarStatus.values.length,
                            (i) {
                              final status = CarStatus.values[i].name;
                              return Expanded(
                                child: DrawableText(
                                  text: status,
                                  textAlign: .center,
                                  size: 12.sp,
                                ),
                              );
                            },
                          ),
                          Expanded(
                            child: DrawableText(
                              text: S.of(context).detailsQuestion,
                              textAlign: .center,
                              size: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      15.0.verticalSpace,
                      ...widget.options.map(
                        (option) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 15.0.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 100.w,
                                  child: DrawableText(text: option.title),
                                ),
                                Expanded(
                                  child: RadioGroup(
                                    groupValue: option.groupValue.call(),
                                    onChanged: (value) {
                                      if (value == null) return;
                                      setState(() => option.onOptionChanged.call(value));
                                      if (value == .intact) {
                                        option.onDetailsButtonTap.call('');
                                      } else {
                                        showAddNote(
                                          context,
                                          title: '${S.of(context).enter} ${option.title}',
                                          onDone: option.onDetailsButtonTap,
                                          initial: option.note.call(),
                                        );
                                      }
                                    },
                                    child: Row(
                                      children:
                                          InspectionStatus.values.map((e) {
                                            return Expanded(
                                              child: Radio(value: e),
                                            );
                                          }).toList()..add(
                                            Expanded(
                                              child: IconButton(
                                                onPressed: () {
                                                  showAddNote(
                                                    context,
                                                    title: '${S.of(context).enter} ${option.title}',
                                                    onDone: option.onDetailsButtonTap,
                                                    initial: option.note.call(),
                                                  );
                                                },
                                                icon: Row(
                                                  spacing: 2.0,
                                                  children: [
                                                    ImageMultiType(
                                                      height: 20.0.r,
                                                      width: 20.0.r,
                                                      url: Assets.icons.edit.path,
                                                      color: (option.groupValue.call()?.index == 0)
                                                          ? AppColorManager.mainColorLight
                                                          : AppColorManager.mainColor,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
