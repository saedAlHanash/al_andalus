import 'dart:ui';

import 'package:al_andalus/features/home/bloc/home_cubit/home_cubit.dart';
import 'package:collection/collection.dart';
import 'package:al_andalus/core/app/app_provider.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/util/shared_preferences.dart';

import 'package:al_andalus/features/home/ui/pages/home_page.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../notification/bloc/all_notification_cubit/all_notification_cubit.dart';

/// ========================================================================
/// Split Floating Navigation Bar - Apple News+ Style
/// ========================================================================
/// تصميم شريط التنقل المنفصل: كبسولة رئيسية + زر منفصل (Menu)
/// يحاكي تصميم Apple News+ مع Glassmorphism وتأثيرات عائمة
/// ========================================================================

class Navbar extends StatefulWidget {
  const Navbar({
    super.key,
    this.isTrainer = false,
  });

  final bool isTrainer;

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeInitial>(
      builder: (context, state) {
        final currentIndex = context.read<HomeCubit>().getIndex;

        final mainItems = [
          (
            icon: _Home(isActive: currentIndex == 0),
            title: S.of(context).home,
          ),
          (
            icon: _Notifications(isActive: currentIndex == 1),
            title: S.of(context).notifications,
          ),
          (
            icon: _Insurance(isActive: currentIndex == 2),
            title: S.of(context).myOrders,
          ),
        ];

        final menuIndex = mainItems.length; // Menu هو آخر عنصر
        final isMenuActive = currentIndex == menuIndex;

        return Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            bottom: 20.h,
          ),
          child: Row(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              // ========== Component A: Main Capsule ==========
              Flexible(
                child: _GlassCapsule(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        mainItems.length,
                        (i) => _NavItem(
                          icon: mainItems[i].icon,
                          title: mainItems[i].title,
                          isActive: i == currentIndex,
                          onTap: () {
                            context.read<HomeCubit>().jumpPage(i);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              15.0.horizontalSpace,

              // ========== Component B: Detached Action Button ==========
              _DetachedButton(
                isActive: isMenuActive,
                title: S.of(context).profile,
                onTap: () {
                  context.read<HomeCubit>().jumpPage(menuIndex);
                },
                icon: ImageMultiType(
                  color: isMenuActive ? Colors.white : AppColorManager.grey,
                  url: Assets.iconsUser,
                  height: 24.0.r,
                  width: 24.0.r,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// ========================================================================
/// الكبسولة الرئيسية مع Glassmorphism
/// ========================================================================
class _GlassCapsule extends StatelessWidget {
  const _GlassCapsule({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 15,
            spreadRadius: 0.5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(50.r),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// ========================================================================
/// الزر المنفصل (Menu) مع Glassmorphism
/// ========================================================================
class _DetachedButton extends StatelessWidget {
  const _DetachedButton({
    required this.isActive,
    required this.onTap,
    required this.icon,
    required this.title,
  });

  final bool isActive;
  final VoidCallback onTap;
  final Widget icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 73.dg,
            height: 73.dg,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.15),
                  blurRadius: 15,
                  spreadRadius: 0.5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: isActive ? theme.primaryColor.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.05),
                      width: 1,
                    ),
                  ),
                  child: icon,
                ),
              ),
            ),
          ),
          // 2.0.verticalSpace,
          // DrawableText(
          //   text: title,
          //   size: 10.sp,
          //   color: isActive ? theme.primaryColor : AppColorManager.grey,
          //   fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          // ),
        ],
      ),
    );
  }
}

/// ========================================================================
/// عنصر التنقل الفردي داخل الكبسولة
/// ========================================================================
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  final Widget icon;
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: isActive ? theme.primaryColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: icon,
            ),
            2.0.verticalSpace,
            DrawableText(
              text: title,
              size: 12.sp,
              color: isActive ? theme.primaryColor : AppColorManager.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ],
        ),
      ),
    );
  }
}

/// ========================================================================
/// أيقونات التنقل الفردية
/// ========================================================================

class _Home extends StatelessWidget {
  const _Home({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return ImageMultiType(
      color: isActive ? Colors.white : AppColorManager.grey,
      url: Assets.iconsHome,
      height: 24.0.r,
      width: 24.0.r,
    );
  }
}

class _Notifications extends StatelessWidget {
  const _Notifications({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationsInitial>(
      builder: (context, state) {
        final notRead = state.result.any((e) => !e.isRead);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            ImageMultiType(
              color: isActive ? Colors.white : AppColorManager.grey,
              url: Assets.iconsNotification,
              height: 24.0.r,
              width: 24.0.r,
            ),
            if (notRead)
              Positioned(
                top: -3,
                right: -3,
                child: Container(
                  height: 11.0.r,
                  width: 11.0.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E676),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00E676).withValues(alpha: 0.5),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Insurance extends StatelessWidget {
  const _Insurance({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return ImageMultiType(
      color: isActive ? Colors.white : AppColorManager.grey,
      url: Assets.iconsClipboardList,
      height: 24.0.r,
      width: 24.0.r,
    );
  }
}

