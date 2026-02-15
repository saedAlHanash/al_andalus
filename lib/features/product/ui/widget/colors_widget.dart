import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../core/extensions/extensions.dart';
import '../../bloc/product_cubit/product_cubit.dart';

class ColorsWidget extends StatefulWidget {
  const ColorsWidget({super.key});

  @override
  State<ColorsWidget> createState() => _ColorsWidgetState();
}

class _ColorsWidgetState extends State<ColorsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductInitial>(
      builder: (context, state) {
        return Row(
          spacing: 3.0.w,
          children: [
            DrawableText(text: 'الألوان: '),
            for (var o in state.result.colors)
              GestureDetector(
                onTap: () {
                  setState(() {
                    state.result.colorId = o.id.toString();
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    shape: .circle,
                    border: state.result.colorId == o.id.toString() ? Border.all(color: AppColorManager.mainColor) : null,
                  ),
                  child: ImageMultiType(
                    url: Icons.circle,
                    width: 24.0.r,
                    color: o.hex.toColor,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
