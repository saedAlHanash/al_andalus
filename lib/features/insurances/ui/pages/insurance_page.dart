import 'package:al_andalus/core/app/app_provider.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/helper/launcher_helper.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/util/my_style.dart';
import 'package:al_andalus/core/widgets/card_slider_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/bottom_sheets.dart';
import '../../../../core/widgets/app_bar/app_bar_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../router/go_router.dart';
import '../../bloc/insurances_cubit/insurances_cubit.dart';
import '../../data/response/insurance_package.dart';
import '../widget/item_insurance.dart';
import '../widget/tapbar_insurances.dart';

class InsurancePage extends StatefulWidget {
  const InsurancePage({
    super.key,
    required this.id,
    required this.estimatedPrice,
    required this.cylindersCount,
    required this.type,
  });

  final String id;
  final double estimatedPrice;
  final int cylindersCount;
  final InsuranceType type;

  @override
  State<InsurancePage> createState() => _InsurancePageState();
}

class _InsurancePageState extends State<InsurancePage> {
  late InsuranceType type;

  @override
  void initState() {
    super.initState();
    type = widget.type;
    context.read<InsurancesCubit>().getData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InsurancesCubit, InsurancesInitial>(
      builder: (context, state) {
        final list = state.result.where((e) => e.type == type).toList()
          ..sort((a, b) => a.level.index.compareTo(b.level.index));
        return Scaffold(
          appBar: AppBarWidget(
            titleText: S.of(context).insurance,
            actions: [
              20.0.horizontalSpace,
              InkWell(
                onTap: () => showSupportCall(context),
                child: ImageMultiType(
                  url: context.isDark ? Assets.iconsSupportBorder : Assets.iconsSupportBorder1,
                  height: 40.0.r,
                  width: 40.0.r,
                ),
              ),
              20.0.horizontalSpace,
            ],
          ),
          body: Column(
            children: [
              20.0.verticalSpace,
              TapBarInsurances(
                type: type,
                onTap: (val) => setState(() => type = val),
                showNote: false,
              ),
              Expanded(
                child: CardSlider1(
                  onPageCh: (i, reason) {},
                  autoPlay: false,
                  viewportFraction: 0.75,
                  height: 1.0.sh,
                  initialPage: list.indexWhere((element) => element.level == InsuranceLevel.gold),
                  images: list.map(
                    (insurance) {
                      insurance
                        ..estimatedPrice = widget.estimatedPrice
                        ..cylindersCount = widget.cylindersCount;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0).r,
                        child: Column(
                          children: [
                            Expanded(child: ItemInsurance(insurance: insurance, isDetail: true)),
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(vertical: 20.0),
                              child: OutLineButton(
                                onTap: () {
                                  if (AppProvider.needLogin) {
                                    AppProvider.insurancePage = {
                                      'id': insurance.id.toString(),
                                      'price': insurance.estimatedPrice.toString(),
                                      'cylindersCount': insurance.cylinder.cylinders.toString(),
                                    };
                                    return;
                                  }

                                  context.pushNamed(
                                    RouteName.addCarPage,
                                    queryParameters: {
                                      'id': insurance.id.toString(),
                                      'price': insurance.price.toString(),
                                      'cylindersCount': insurance.cylinder.cylinders,
                                      'name': insurance.title,
                                    },
                                  );
                                },
                                text: S.of(context).subscribeNow,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
