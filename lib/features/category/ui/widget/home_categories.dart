// Section title with optional action
import 'package:al_andalus/core/widgets/see_all_header.dart';
import 'package:al_andalus/features/category/ui/widget/item_category.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/l10n.dart';
import '../../../../router/app_router.dart';
import '../../bloc/categories_cubit/categories_cubit.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SeeAllHeader(
          title: S.of(context).sections,
          // onTap: () {
          //   Navigator.pushNamed(
          //     context,
          //     RouteName.categories,
          //   );
          // },
        ),
        Container(
          height: 100.0.h,
          decoration: BoxDecoration(
            // border: Border.all(color: AppColorManager.cardColor),
            borderRadius: BorderRadius.circular(12.0.r),
          ),
          padding: EdgeInsets.all(7.0).r,
          margin: EdgeInsets.symmetric(vertical: 7.0).r,
          child: BlocBuilder<CategoriesCubit, CategoriesInitial>(
            builder: (context, state) {
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  final category = state.result[i];
                  return ItemCategory(
                    category: category,
                    onTap: (category) {

                    },
                  );
                },
                separatorBuilder: (context, i) => 10.0.horizontalSpace,
                itemCount: state.result.length,
              );
            },
          ),
        ),
      ],
    );
  }
}
