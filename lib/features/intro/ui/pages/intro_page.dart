import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/util/shared_preferences.dart';
import 'package:al_andalus/router/app_router.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/assets.dart';
import '../widget/intro_card_widget.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;


  final List<IntroPageModel> _pages = [
    IntroPageModel(
      image: Assets.imagesIntro1, // ضع صورتك هنا
      title: 'الإبلاغ عن حادث',
      description: 'التعويض أسهل الآن.. صوّر الضرر وارفع طلبك فوراً..\nونحن نعتني بالباقي',
    ),
    IntroPageModel(
      image: Assets.imagesIntro2, // ضع صورتك هنا
      title: 'نقل ملكية وثيقة التأمين',
      description: 'نقل ملكية وثيقة التأمين بسهولة إلى مستخدم آخر عن طريق رمز ال QR',
    ),
    IntroPageModel(
      image: Assets.imagesIntro3, // ضع صورتك هنا
      title: 'تأمين سيارة',
      description: 'أمن مركبتك خلال دقائق، واطّلع على وثيقتك وكل تفاصيلها مباشرة من حسابك',
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
      Navigator.pushReplacementNamed(context, RouteName.home);
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
              itemBuilder: (context, index) {
                final page = _pages[index];
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
                      child: DrawableText(text: 'تخطي', color: AppColorManager.grey, size: 16.0.sp),
                    ),
                    // Page Indicators
                    Row(children: List.generate(_pages.length, (index) => _buildPageIndicator(index))),

                    // Next Button
                    TextButton(
                      onPressed: _nextPage,
                      child: DrawableText(text: 'التالي', color: AppColorManager.black, size: 16.0.sp),
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

  Widget _buildPageIndicator(int index) {
    bool isActive = _currentPage == index;
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
