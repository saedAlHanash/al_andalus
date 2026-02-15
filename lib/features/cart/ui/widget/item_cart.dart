import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/util/snack_bar_message.dart';
import 'package:al_andalus/features/product/ui/pages/product_page.dart';
import 'package:al_andalus/router/app_router.dart';
import 'package:collection/collection.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:image_multi_type/round_image_widget.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../../../generated/assets.dart';
import '../../../product/data/response/product_response.dart';
import '../../bloc/cart_cubit/cart_cubit.dart';

class ItemProductCart extends StatelessWidget {
  const ItemProductCart({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColorManager.cardColor),
        borderRadius: BorderRadius.circular(8.0.r),
      ),
      padding: EdgeInsets.all(15.0).r,
      margin: const EdgeInsets.symmetric(vertical: 10.0).r,
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, RouteName.product, arguments: product.id);
              },
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.zero,
              leading: RoundImageWidget(
                url: product.image.firstOrNull,
                width: 50.0.r,
                height: 50.0.r,
              ),
              title: DrawableText(
                text: product.name,
                maxLines: 1,
                matchParent: true,
              ),
              subtitle: Column(
                mainAxisSize: .min,
                children: [
                  DrawableText(
                    padding: EdgeInsets.only(top: 10.0),
                    text: 'اللون المختار: ',
                    color: AppColorManager.black,
                    drawableAlin: .withText,
                    matchParent: true,
                    drawableEnd: ImageMultiType(
                      url: Icons.circle,
                      width: 24.0.r,
                      color: (product.colors.firstWhereOrNull((e) => e.id.toString() == product.colorId))?.hex.toColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              NoteMessage.showCheckDialog(
                context,
                text: 'هل تريد ازالة المنتج من السلة؟',
                textButton: 'إزالة المنتج',
                onConfirm: () {
                  context.read<CartCubit>().removeFromCart(product);
                },
              );
            },
            icon: ImageMultiType(url: Assets.iconsDelete),
          ),
          AmountWidgetCart(
            product: product,
            axis: Axis.vertical,
            onDecrement: (product) {
              context.read<CartCubit>().decrementQuantity(product);
            },
            onIncrement: (product) {
              context.read<CartCubit>().incrementQuantity(product, context: context);
            },
          ),
        ],
      ),
    );
  }
}
