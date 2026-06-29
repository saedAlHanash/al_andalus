import 'package:al_andalus/features/ads/ui/widgets/adds_slider.dart';
import 'package:al_andalus/features/home/ui/widget/hi_widget.dart';
import 'package:al_andalus/features/home/ui/widget/how_can_help.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../../router/go_router.dart';
import '../../../cars/bloc/home_cars_cubit/home_cars_cubit.dart';
import '../../../cars/ui/widget/list_cars.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCarsCubit, HomeCarsInitial>(
      listenWhen: (p, c) => c.done && c.url.isNotEmpty,
      listener: (context, state) {
        context.read<HomeCarsCubit>().doneOpenUrl();
        context.pushNamed(RouteName.webView, queryParameters: {'url': state.url}).then(
          (value) {
            if (context.mounted) {
              context.pushNamed(
                RouteName.paymentSuccess,
                extra: state.mRequest,
                queryParameters: {
                  'isSuccessPayment': (value == true).toString(),
                  'isRepay': true.toString(),
                },
              );
            }
          },
        );
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0).r,

          child: Column(
            children: [
              HiWidget(),
              Expanded(
                child: ListView(
                  children: [
                    10.0.verticalSpace,
                    AddsSlider(type: AdsType.slider, height: 150.0),
                    HowCanHelp(),
                    ListCars(take: 1),
                    20.0.verticalSpace,
                    AddsSlider(type: AdsType.banner, height: 90.0),
                    150.0.verticalSpace,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
