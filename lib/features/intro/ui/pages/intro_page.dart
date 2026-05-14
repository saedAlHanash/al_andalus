import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/util/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:al_andalus/router/go_router.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart'; // Added this import
import '../widget/intro_card_widget.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<IntroPageModel> get _pages => [
    IntroPageModel(
      image: Assets.imagesIntro3,
      title: S.of(context).insureCarIntroTitle,
      description: S.of(context).insureCarIntroDesc,
    ),
    IntroPageModel(
      image: Assets.imagesIntro2,
      title: S.of(context).transferOwnershipIntroTitle,
      description: S.of(context).transferOwnershipIntroDesc,
    ),
    IntroPageModel(
      image: Assets.imagesIntro1,
      title: S.of(context).reportAccidentIntroTitle,
      description: S.of(context).reportAccidentIntroDesc,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishIntro();
    }
  }

  void _finishIntro() async {
    // حفظ حالة مشاهدة الـ intro
    await AppSharedPreference.setHasSeenIntro(true);

    // الانتقال إلى صفحة تسجيل الدخول
    if (mounted) {
      Navigator.of(context).context.goNamed(RouteName.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorManager.white,
      body: SafeArea(
        child: Stack(
          children: [
            // PageView
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _pages.length,
              itemBuilder: (context, i) {
                final page = _pages[i];
                return IntroCardWidget(image: page.image, title: page.title, description: page.description);
              },
            ),

            // Skip Button

            // Bottom Section (Indicators + Next Button)
            Positioned(
              bottom: 40.0.h,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _finishIntro,
                      child: DrawableText(text: S.of(context).skip, color: AppColorManager.grey, size: 16.0.sp),
                    ),
                    // Page Indicators
                    Row(children: List.generate(_pages.length, (i) => _buildPageIndicator(i))),

                    // Next Button
                    TextButton(
                      onPressed: _nextPage,
                      child: DrawableText(text: S.of(context).next, color: AppColorManager.black, size: 16.0.sp),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int i) {
    bool isActive = _currentPage == i;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.only(right: 8.0.w),
      width: isActive ? 24.0.w : 8.0.w,
      height: 8.0.h,
      decoration: BoxDecoration(
        color: isActive ? AppColorManager.mainColor : AppColorManager.grey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4.0.r),
      ),
    );
  }
}

// Model للصفحة
class IntroPageModel {
  final String image;
  final String title;
  final String description;

  IntroPageModel({required this.image, required this.title, required this.description});
}
