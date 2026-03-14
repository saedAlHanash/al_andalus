import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/widgets/my_card_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

class CardSlider extends StatelessWidget {
  const CardSlider({
    super.key,
    this.stackChild,
    required this.images,
    this.height,
    this.width,
  });

  final List<Widget>? stackChild;
  final Iterable<String> images;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<IndicatorSliderWidgetState>();
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0.r),
            color: AppColorManager.lightGray,
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: width,
                height: height ?? 160.0.h,
                child: CarouselSlider(
                  items: images.map(
                    (e) {
                      return ImageMultiType(
                        url: e,
                        height: 1.0.sh,
                        width: width ?? 1.0.sw,
                        fit: BoxFit.fill,
                      );
                    },
                  ).toList(),
                  options: CarouselOptions(
                    height: height ?? 160.0.h,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlay: images.length > 1,
                    viewportFraction: 1,
                    onPageChanged: (i, reason) {
                      key.currentState!.changePage(i);
                    },
                  ),
                ),
              ),

              ...?stackChild,
            ],
          ),
        ),
        10.0.verticalSpace,
        IndicatorSliderWidget(
          key: key,
          length: images.length,
        ),
      ],
    );
  }
}

class CardImageSlider extends StatefulWidget {
  const CardImageSlider({
    super.key,
    this.margin,
    this.stackChild,
    required this.images,
    this.height,
    this.width,
    this.onChange,
    this.card = false,
  });

  final EdgeInsets? margin;
  final List<Widget>? stackChild;
  final List<Widget> images;
  final double? height;
  final double? width;
  final bool card;
  final Function()? onChange;

  @override
  State<CardImageSlider> createState() => CardImageSliderState();
}

class CardImageSliderState extends State<CardImageSlider> {
  late final CarouselSliderController controller;

  late int currentImage;

  void setIndex(int i) {
    key.currentState?.changePage(i);
    currentImage = i;
    controller.animateToPage(currentImage);
  }

  @override
  void initState() {
    controller = CarouselSliderController();
    currentImage = 0;
    super.initState();
  }

  final key = GlobalKey<IndicatorSliderWidgetState>();

  @override
  Widget build(BuildContext context) {
    Widget widgetSlider = Stack(
      alignment: AlignmentGeometry.center,
      children: [
        SizedBox(
          width: widget.width,
          height: widget.height,
          child: CarouselSlider(
            carouselController: controller,
            items: widget.images.map((e) => e).toList(),
            options: CarouselOptions(
              height: widget.height,
              autoPlayInterval: const Duration(seconds: 10),
              viewportFraction: 1,
              enableInfiniteScroll: true,
              onPageChanged: (i, reason) {
                key.currentState!.changePage(i);
                currentImage = i;
                widget.onChange?.call();
              },
            ),
          ),
        ),
        Positioned(
          bottom: 5.0.h,
          child: IndicatorSliderWidget(
            key: key,
            length: widget.images.length,
            selectedColor: AppColorManager.mainColor,
            unselectedColor: AppColorManager.grey,
          ),
        ),
        if (widget.stackChild != null) ...widget.stackChild!,
      ],
    );
    if (widget.card) {
      widgetSlider = MyCardWidget(
        padding: EdgeInsets.zero,
        margin: widget.margin,
        cardColor: Colors.white,
        elevation: 0.0,
        child: widgetSlider,
      );
    }
    return widgetSlider;
  }
}

class IndicatorSliderWidget extends StatefulWidget {
  const IndicatorSliderWidget({
    super.key,
    required this.length,
    this.selectedColor,
    this.unselectedColor,
  });

  final int length;
  final Color? selectedColor;
  final Color? unselectedColor;

  @override
  State<IndicatorSliderWidget> createState() => IndicatorSliderWidgetState();
}

class IndicatorSliderWidgetState extends State<IndicatorSliderWidget> {
  int? selected;

  void changePage(int i) {
    setState(() => selected = i);
  }

  @override
  void initState() {
    selected = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.length < 2) return 0.0.verticalSpace;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.0).r,
      height: 12.0.h,
      child: ListView.separated(
        itemCount: widget.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          // return ImageMultiType(url: Icons.celebration);
          return AnimatedContainer(
            height: 5.0.h,
            margin: EdgeInsets.symmetric(vertical: 2.0),
            width: selected == i ? 21.0.w : 12.0.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: selected == i
                  ? (widget.selectedColor ?? (context.isDark ? AppColorManager.mainColorLight : AppColorManager.mainColor))
                  : (widget.unselectedColor ?? AppColorManager.dividerColor),
            ),
            duration: const Duration(milliseconds: 150),
          );
        },
        separatorBuilder: (context, i) => 5.0.horizontalSpace,
      ),
    );
  }
}

class CardSlider1 extends StatelessWidget {
  const CardSlider1({
    super.key,
    this.margin,
    required this.images,
    this.height,
    this.width,
    this.viewportFraction,
    this.seconds,
    this.initialPage,
    this.autoPlay,
    this.onPageCh,
  });

  final EdgeInsets? margin;
  final List<Widget> images;
  final double? height;
  final double? viewportFraction;
  final double? width;
  final int? seconds;
  final int? initialPage;
  final bool? autoPlay;
  final Function(int i, CarouselPageChangedReason reason)? onPageCh;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: images,

      options: CarouselOptions(
        autoPlayInterval: Duration(seconds: seconds ?? 6),
        autoPlay: autoPlay ?? true,
        initialPage: initialPage ?? 0,
        // disableCenter: true,
        viewportFraction: viewportFraction ?? 1,
        height: height,
        enlargeCenterPage: true,
        pauseAutoPlayInFiniteScroll: false,
        disableCenter: true,
        enableInfiniteScroll: false,
        animateToClosest: true,
        pageSnapping: true,
        pauseAutoPlayOnTouch: true,
        pauseAutoPlayOnManualNavigate: true,
        padEnds: true,

        onPageChanged: onPageCh,
      ),
    );
    // return Column(
    //   children: [
    //     IndicatorSliderWidget(key: key, length: images.length),
    //   ],
    // );
  }
}
