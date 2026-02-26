import 'package:al_andalus/core/app/app_provider.dart';
import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/features/home/ui/pages/home_screen_guest.dart';

import 'package:al_andalus/features/notification/ui/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/my_style.dart';
import '../../../auth/bloc/delete_account_cubit/delete_account_cubit.dart';
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
            color: Colors.white,
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
                      NotificationPage(),
                      Container(),
                      MenuScreen(),
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
