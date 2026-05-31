import 'package:al_andalus/core/app/app_provider.dart';
import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/features/home/ui/pages/home_screen_guest.dart';

import 'package:al_andalus/features/notification/ui/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/util/my_style.dart';
import '../../../../router/go_router.dart';
import '../../../auth/bloc/delete_account_cubit/delete_account_cubit.dart';
import '../../../cars/bloc/home_cars_cubit/home_cars_cubit.dart';
import '../../../cars/ui/widget/list_cars.dart';
import '../../bloc/home_cubit/home_cubit.dart';
import '../widget/bottom_nav_widget.dart';
import '../widget/screens/menu_screen.dart';

import 'home_screen.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  HomeCubit get cubit => context.read<HomeCubit>();

  @override
  void dispose() {
    cubit.state.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeInitial>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBarWidget(
            titleText: state.getLabel,
            onPopInvoked: (isPop, result) => cubit.jumpPage(0),
            canPop: cubit.canPop,
            zeroHeight: true,
          ),
          body: Stack(
            children: [
              BlocBuilder<DeleteAccountCubit, DeleteAccountInitial>(
                buildWhen: (p, c) => c.done,
                builder: (context, dState) {
                  if (dState.loading) {
                    return MyStyle.loadingWidget();
                  }
                  return PageView(
                    controller: state.controller,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      AppProvider.isGuest ? GuestHomeScreen() : const HomeScreen(),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0, bottom: 150.0).r,
                        child: NotificationPage(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0, bottom: 150.0).r,
                        child: BlocListener<HomeCarsCubit, HomeCarsInitial>(
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
                          child: ListCars(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0, bottom: 150.0).r,
                        child: MenuScreen(),
                      ),
                    ],
                  );
                },
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Navbar(),
              ),
            ],
          ),
        );
      },
    );
  }
}
