import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/util/my_style.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../../generated/assets.dart';
import '../../../bloc/cars_cubit/cars_cubit.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}
//project architecture standard
class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarsCubit, CarsInitial>(
      builder: (context, state) {
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0).r,
          children: [
            DrawableText(text: 'قم بتحديد طريقة الدفع المرغوبة'),

            20.0.verticalSpace,
            Container(
              decoration: MyStyle.roundBox12(
                state.mRequest.paymentType == .qiCard ? AppColorManager.mainColor.withValues(alpha: 0.1) : Colors.white,
              ),
              child: ListTile(
                onTap: () {
                  setState(() {
                    state.mRequest.paymentType = .qiCard;
                  });
                },
                title: DrawableText(text: 'بطاقة الكترونية'),
                subtitle: DrawableText(text: 'سيتم الدفع عبر البطاقة الالكترونية'),
                trailing: ImageMultiType(
                  url: Assets.imagesVisa,
                  width: 71.0.w,
                ),
              ),
            ),

            25.0.verticalSpace,
            Container(
              decoration: MyStyle.roundBox12(
                state.mRequest.paymentType == .zainCash
                    ? AppColorManager.mainColor.withValues(alpha: 0.3)
                    : Colors.white,
              ),
              child: ListTile(
                onTap: () {
                  setState(() {
                    state.mRequest.paymentType = .zainCash;
                  });
                },
                title: DrawableText(text: 'محفظة زين كاش'),
                subtitle: DrawableText(text: 'سيتم الدفع من خلال المحفظة'),
                trailing: ImageMultiType(
                  url: Assets.imagesZainCash,
                  width: 71.0.w,
                ),
              ),
            ),
            30.0.verticalSpace,
            DrawableText(
              text: 'تكلفة الباقة السنوية',
              padding: EdgeInsets.symmetric(vertical: 15.0).r,
              matchParent: true,
              drawableAlin: .between,
              drawableEnd: DrawableText(text: 'text'),
            ),
            DrawableText(
              text: 'تكاليف إضافية',
              padding: EdgeInsets.symmetric(vertical: 10.0).r,
              matchParent: true,
              drawableAlin: .between,
              drawableEnd: DrawableText(text: 'text'),
            ),
            Divider(),
            DrawableText(
              text: 'المجموع الكلي',
              padding: EdgeInsets.symmetric(vertical: 10.0).r,
              matchParent: true,
              drawableAlin: .between,
              drawableEnd: DrawableText(text: 'text'),
            ),
          ],
        );
      },
    );
  }
}
