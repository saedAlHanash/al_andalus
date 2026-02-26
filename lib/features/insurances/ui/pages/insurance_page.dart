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
                text: 'اشترك الان',
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
                                      onPressed: () {

                                      },
                                      child: DrawableText(
                                        text: 'معرفه التفاصيل ',
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
                        text: '/سنويا',
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    DrawableText(
                      text: 'المميزات',

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

Future<void> f() async {
  var headers = {
    'Accept': 'application/json',
    'Accept-Charset': 'application/json',
    'Authorization': '••••••'
  };
  var request = http.MultipartRequest('POST', Uri.parse('https://admin.andalusapp.com/client/v1/insurance-policy'));
  request.fields.addAll({
    'insurance_package_id': ' 1',
    'cylinders': '6',
    'name': '456',
    'manufacture_year': '1990',
    'color': 'red',
    'brand': '123',
    'value': '50000',
    'chassis_number': '888888888888',
    'plate_number': '99999',
    'fuel_type': 'hybrid',
    'engine_capacity': '5000',
    'inspection[metal_body]': 'missing',
    'inspection[metal_body_note]': '',
    'inspection[chrome_nickel]': 'intact',
    'inspection[chrome_nickel_note]': '',
    'inspection[brand_sign]': 'damage',
    'inspection[brand_sign_note]': 'damage notes',
    'inspection[windshield_wipers]': 'missing',
    'inspection[windshield_wipers_note]': '',
    'inspection[radio_antenna]': 'intact',
    'inspection[radio_antenna_note]': 'test note',
    'inspection[seats]': 'intact',
    'inspection[seats_note]': '',
    'inspection[floor_cover]': 'intact',
    'inspection[floor_cover_note]': 'test',
    'inspection[radio]': 'intact',
    'inspection[radio_note]': '',
    'inspection[air_conditioner]': 'intact',
    'inspection[air_conditioner_note]': '',
    'inspection[front_tires]': 'intact',
    'inspection[front_tires_note]': '',
    'inspection[back_tires]': 'intact',
    'inspection[back_tires_note]': '',
    'inspection[spare_tire]': 'intact',
    'inspection[spare_tire_note]': '',
    'inspection[tires_covers]': 'intact',
    'inspection[tires_covers_note]': '',
    'inspection[spare_tools]': 'intact',
    'inspection[spare_tools_note]': '',
    'inspection[other_notes]': '',
    'payment_type': 'zain_cash',
    'expiry_start_date': '2025-02-19',
    'expiry_end_date': '2026-02-19',
    'inspection[glass_and_lamps]': 'intact',
    'inspection[glass_and_lamps_note]': 'dd',
    'expiry_start_date': '2025-02-19',
    'expiry_end_date': '2026-02-19'
  });
  request.files.add(await http.MultipartFile.fromPath('ownership_front_image', 'snn2e72Kx/avatar.jpg'));
  request.files.add(await http.MultipartFile.fromPath('ownership_back_image', '_Bhz_F2Ja/avatar.jpg'));
  request.files.add(await http.MultipartFile.fromPath('attachments[front_image]', 'ScGrWu2BX/default.png'));
  request.files.add(await http.MultipartFile.fromPath('attachments[back_image]', 'eJNlfRUhG/avatar.jpg'));
  request.files.add(await http.MultipartFile.fromPath('attachments[right_side_image]', '-eugLXfMn/default.png'));
  request.files.add(await http.MultipartFile.fromPath('attachments[left_side_image]', '8KefspVHs/avatar.jpg'));
  request.files.add(await http.MultipartFile.fromPath('attachments[interior_image]', 'zGYkfuEtL/avatar.jpg'));
  request.files.add(await http.MultipartFile.fromPath('attachments[engine_image]', '5T0xsFG0q/avatar.jpg'));
  request.files.add(await http.MultipartFile.fromPath('inspection_report', 'Yh5DMafI0/YaraKleeb.pdf'));
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
  }
  else {
  print(response.reasonPhrase);
  }

}