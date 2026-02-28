import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/helper/launcher_helper.dart';
import 'package:al_andalus/core/util/my_style.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../core/util/bottom_sheets.dart';
import '../../../../core/widgets/app_bar/app_bar_widget.dart';
import '../../../../core/widgets/refresh_widget/refresh_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/insurance_cubit/insurance_cubit.dart';

class InsurancePage extends StatelessWidget {
  const InsurancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<InsuranceCubit, InsuranceInitial>(
          listenWhen: (p, c) => c.done,
          listener: (context, state) {},
        ),
      ],
      child: BlocBuilder<InsuranceCubit, InsuranceInitial>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBarWidget(
              titleText: state.result.title,
              actions: [
                20.0.horizontalSpace,
                InkWell(
                  onTap: () => showSupportCall(context),
                  child: ImageMultiType(
                    url: Assets.iconsSupportBorder,
                    height: 40.0.r,
                    width: 40.0.r,
                  ),
                ),
                20.0.horizontalSpace,
              ],
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsetsGeometry.all(20.0),
              child: MyButton(
                onTap: () {},
                text: S.of(context).subscribeNow,
              ),
            ),
            body: BlocBuilder<InsuranceCubit, InsuranceInitial>(
              builder: (context, state) {
                return RefreshWidget(
                  isLoading: state.loading,
                  onRefresh: () {
                    context.read<InsuranceCubit>().getData(newData: true);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0).r,
                    child: Column(
                      children: [
                        _Top(),
                        2.0.verticalSpace,
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.0).r),
                              boxShadow: MyStyle.allShadow,
                            ),
                            child: Column(
                              children:
                                  state.result.features.map((feature) {
                                    return ListTile(
                                          leading: ImageMultiType(
                                            url: Assets.iconsDoneStep,
                                            height: 20.0.r,
                                            width: 20.0.r,
                                          ),
                                          title: DrawableText(text: feature.title),
                                        )
                                        as Widget;
                                  }).toList()..addAll([
                                    Spacer(),
                                    TextButton(
                                      onPressed: () {},
                                      child: DrawableText(
                                        text: S.of(context).knowMoreDetails,
                                        textDecoration: .underline,
                                      ),
                                    ),
                                    20.0.verticalSpace,
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _Top extends StatelessWidget {
  const _Top({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InsuranceCubit, InsuranceInitial>(
      builder: (context, state) {
        return Container(
          height: 250.0.h,
          clipBehavior: .hardEdge,
          width: 1.0.sw,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0).r),
            boxShadow: MyStyle.allShadow,
          ),
          child: Stack(
            children: [
              ImageMultiType(
                height: 1.0.sh,
                width: 1.0.sw,
                url: Assets.iconsTopCard,
                color: state.result.level.color,
                fit: .fill,
              ),
              Padding(
                padding: const EdgeInsets.all(35.0),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4.0).r,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                        ),
                      ),
                      child: DrawableText(
                        text: state.result.title,
                        color: Colors.white,
                        size: 20.0.sp,
                      ),
                    ),
                    20.0.verticalSpace,
                    DrawableText(
                      text: state.price.formatPrice,
                      color: Colors.white,
                      size: 32.0.sp,
                      drawableEnd: DrawableText(
                        text: '/${S.of(context).annually}',
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    DrawableText(
                      text: S.of(context).features,

                      size: 18.0.sp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
