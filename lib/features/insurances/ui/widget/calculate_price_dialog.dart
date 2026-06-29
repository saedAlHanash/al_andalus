import 'dart:convert';

import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../core/app/app_widget.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/strings/app_color_manager.dart';
import '../../../../core/util/bottom_sheets.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/my_checkbox_widget.dart';
import '../../../../core/widgets/my_text_form_widget.dart';
import '../../../../core/widgets/spinner_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../data/response/insurance_package.dart';

class CalculatePriceDialog extends StatefulWidget {
  const CalculatePriceDialog({super.key, required this.context, this.insurancePackage, required this.onTap});

  final BuildContext context;
  final InsurancePackage? insurancePackage;
  final Function(Map<String, String> queryParameters) onTap;

  @override
  State<CalculatePriceDialog> createState() => _CalculatePriceDialogState();
}

class _CalculatePriceDialogState extends State<CalculatePriceDialog> {
  var cylindersCount = 0;

  var p = 0.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx!).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeaderBottomSheet(),
            Container(
              color: AppColorManager.cardColor,
              padding: EdgeInsets.all(20.0).r,
              child: Column(
                children: [
                  TitleBottomSheet(title: S.of(context).calculateInsuranceCost),
                  10.0.verticalSpace,
                  DrawableText(
                    text: S.of(context).chooseEngineCapacity,
                    matchParent: true,
                  ),
                  MyCheckboxWidget(
                    items:
                        widget.insurancePackage?.getCylinders ??
                        [
                          SpinnerItem(name: '4', id: 4),
                          SpinnerItem(name: '6', id: 6),
                          SpinnerItem(name: '8', id: 8),
                        ],
                    onSelected: (value, i, isSelected) {
                      setState(() {
                        cylindersCount =
                            int.tryParse(value.name) ??
                            (value.item is Cylinder ? int.parse((value.item as Cylinder).cylinders) : value.id);
                      });
                    },
                    isRadio: true,
                    buttonBuilder: (selected, value, context) {
                      return Container(
                        width: 0.25.sw,
                        margin: EdgeInsets.symmetric(horizontal: 5.0).w,
                        child: ListTile(
                          tileColor: AppColorManager.cd,
                          title: DrawableText(text: value.name),
                          leading: ImageMultiType(
                            url: selected ? Assets.icons.radio.path : Icons.radio_button_off,
                            height: 24.0.r,
                            width: 24.0.r,
                          ),
                        ),
                      );
                    },
                  ),
                  10.0.verticalSpace,
                  MyTextFormOutLineWidget(
                    onChanged: (p0) {
                      setState(() {
                        p = double.parse(p0.numberOnly.toString());
                      });
                    },
                    inputFormatters: [
                      PriceInputFormatter(currencySymbol: S.of(context).currencySymbol),
                    ],
                    keyBordType: .number,
                    labelText: S.of(context).enterCarValue,
                    hint: '0.0',
                  ),
                  10.0.verticalSpace,
                  MyButton(
                    onTap: () {
                      widget.onTap.call(
                        {
                          'id': widget.insurancePackage?.id.toString() ?? "",
                          'price': p.toString(),
                          'cylindersCount': cylindersCount.toString(),
                          'json': jsonEncode(widget.insurancePackage?.toJson()),
                        },
                      );
                    },
                    enable: cylindersCount > 0 && p > 0,
                    text: S.of(context).startNow,
                  ),
                  30.0.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
