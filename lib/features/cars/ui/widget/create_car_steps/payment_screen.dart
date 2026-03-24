import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/util/my_style.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../../generated/assets.dart';
import '../../../../../generated/l10n.dart';
import '../../../bloc/cars_cubit/cars_cubit.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarsCubit, CarsInitial>(
      builder: (context, state) {
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0).r,
          children: [
            DrawableText(text: S.of(context).selectPaymentMethod),

            20.0.verticalSpace,
            Container(
              decoration: MyStyle.roundBox12(
                color: state.mRequest.paymentType == .qiCard ? AppColorManager.mainColorLight : null,
              ),
              child: ListTile(
                onTap: () {
                  setState(() {
                    state.mRequest.paymentType = .qiCard;
                  });
                },
                title: DrawableText(text: S.of(context).electronicCard),
                subtitle: DrawableText(text: S.of(context).paymentViaElectronicCard),
                trailing: ImageMultiType(
                  url: Assets.imagesVisa,
                  width: 71.0.w,
                ),
              ),
            ),

            25.0.verticalSpace,
            Container(
              decoration: MyStyle.roundBox12(
                color: state.mRequest.paymentType == .zainCash ? AppColorManager.secondColor : null,
              ),
              child: ListTile(
                onTap: () {
                  setState(() {
                    state.mRequest.paymentType = .zainCash;
                  });
                },
                title: DrawableText(text: S.of(context).zainCashWallet),
                subtitle: DrawableText(text: S.of(context).paymentViaWallet),
                trailing: ImageMultiType(
                  url: Assets.imagesZainCash,
                  width: 71.0.w,
                ),
              ),
            ),
            30.0.verticalSpace,
            DrawableText(
              text: S.of(context).annualPackageCost,
              padding: EdgeInsets.symmetric(vertical: 15.0).r,
              matchParent: true,
              drawableAlin: .between,
              drawableEnd: DrawableText(text: state.mRequest.value.toString()),
            ),
            DrawableText(
              text: S.of(context).additionalCosts,
              padding: EdgeInsets.symmetric(vertical: 10.0).r,
              matchParent: true,
              drawableAlin: .between,
              drawableEnd: DrawableText(text: '0'),
            ),
            Divider(),
            DrawableText(
              text: S.of(context).totalAmount,
              padding: EdgeInsets.symmetric(vertical: 10.0).r,
              matchParent: true,
              drawableAlin: .between,
              drawableEnd: DrawableText(text: state.mRequest.value.toString()),
            ),
          ],
        );
      },
    );
  }
}
