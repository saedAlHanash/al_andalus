import 'dart:ui';

import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/features/home/bloc/home_cubit/home_cubit.dart';
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
            title: S.of(context).insurance,
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
            spacing: 10.0.w,
            textDirection: TextDirection.rtl,

            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              // ========== Component A: Main Capsule ==========
              Flexible(
                child: _GlassCapsule(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      textDirection: TextDirection.rtl,
                      children: List.generate(
                        mainItems.length,
                        (i) => _NavItem(
                          icon: mainItems[i].icon,
                          title: mainItems[i].title,
                          isActive: i == currentIndex,
                          onTap: () => context.read<HomeCubit>().jumpPage(i),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // ========== Component B: Detached Action Button ==========
              _DetachedButton(
                isActive: isMenuActive,
                title: S.of(context).profile,
                onTap: () {
                  context.read<HomeCubit>().jumpPage(menuIndex);
                },
                icon: ImageMultiType(
                  color: isMenuActive ? Colors.white : (context.isDark ? Colors.white70 : AppColorManager.grey),
                  url: Assets.icons.user.path,
                  height: 20.0.r,
                  width: 20.0.r,
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
            color: Colors.black.withValues(alpha: context.isDark ? 0.4 : 0.15),
            blurRadius: 15,
            spreadRadius: 0.5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
          child: Container(
            decoration: BoxDecoration(
              color: AppColorManager.cardColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(50.r),
              border: Border.all(
                color: AppColorManager.dividerColor.withValues(alpha: 0.1),
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
      child: Container(
        width: 60.dg,
        height: 60.dg,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: context.isDark ? 0.4 : 0.15),
              blurRadius: 15,
              spreadRadius: 0.5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
            child: Container(
              padding: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                color: isActive ? theme.primaryColor : AppColorManager.cardColor.withValues(alpha: 0.5),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColorManager.dividerColor.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: icon,
            ),
          ),
        ),
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
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: isActive ? theme.primaryColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: icon,
            ),
            if (isActive) 2.0.verticalSpace,
            DrawableText(
              text: title,
              size: 11.sp,
              color: isActive ? theme.primaryColor : (context.isDark ? Colors.white70 : AppColorManager.grey),
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
            if (!isActive) 2.0.verticalSpace,
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
      color: isActive ? Colors.white : (context.isDark ? Colors.white70 : AppColorManager.grey),
      url: Assets.icons.home.path,
      height: 20.0.r,
      width: 20.0.r,
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
        final notRead = /*state.result.any((e) => !e.isRead)*/ false;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            ImageMultiType(
              color: isActive ? Colors.white : (context.isDark ? Colors.white70 : AppColorManager.grey),
              url: Assets.icons.notification.path,
              height: 20.0.r,
              width: 20.0.r,
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
      color: isActive ? Colors.white : (context.isDark ? Colors.white70 : AppColorManager.grey),
      url: Assets.icons.clipboardList.path,
      height: 20.0.r,
      width: 20.0.r,
    );
  }
}
