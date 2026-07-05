import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/util/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

var primaryColor = AppColorManager.mainColor;
var secondaryColor = AppColorManager.white;
const _dividerColor = Color(0xFFECEDF2);

String? get appFontFamily {
  try {
    if (AppSharedPreference.getLocal == 'ur') {
      return FontManager.bold.name;
    }
    return GoogleFonts.getFont('Cairo').fontFamily;
  } catch (_) {
    return GoogleFonts.getFont('Cairo').fontFamily;
  }
}

ThemeData get lightTheme => ThemeData(
  progressIndicatorTheme: ProgressIndicatorThemeData(
    borderRadius: BorderRadius.circular(8.0),
    linearMinHeight: 7.0,
    strokeCap: StrokeCap.round,
  ),
  primaryColorDark: Colors.grey[200],

  textTheme: TextTheme(
    bodyMedium: TextStyle(fontSize: 14.0.sp, fontFamily: appFontFamily),
  ),
  fontFamily: appFontFamily,
  dividerColor: _dividerColor,
  dividerTheme: DividerThemeData(
    color: _dividerColor,
  ),
  primaryTextTheme: TextTheme(
    displayMedium: TextStyle(
      fontFamily: appFontFamily,
      color: Color(0xFF132332),
    ),
  ),
  listTileTheme: kDebugMode
      ? null
      : ListTileThemeData(
          horizontalTitleGap: 10.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0.r)),
          controlAffinity: ListTileControlAffinity.leading,
        ),
  brightness: Brightness.light,
  primaryColor: primaryColor,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColorManager.secondColor,
    selectionColor: AppColorManager.secondColor.withValues(alpha: 0.7),
    selectionHandleColor: AppColorManager.secondColor,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: AppColorManager.lightGray,
    surfaceTintColor: AppColorManager.lightGray,
    iconTheme: IconThemeData(color: AppColorManager.mainColor),
    titleTextStyle: TextStyle(
      color: Color(0xFF132332),
      fontFamily: appFontFamily,
      fontSize: 18.sp,
    ),
  ),
  cardColor: Colors.white,
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0.r)),
  ),
  colorScheme: ColorScheme.light(
    primary: primaryColor,
    secondary: AppColorManager.secondColor,
    surface: secondaryColor,
    error: AppColorManager.red,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return primaryColor;
      return AppColorManager.lightGrayAb;
    }),
    trackOutlineColor: WidgetStatePropertyAll(AppColorManager.mainColor),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColorManager.mainColorLight.withValues(alpha: 0.5);
      }
      return AppColorManager.lightGrayEd;
    }),
  ),
  tabBarTheme: TabBarThemeData(
    dividerColor: AppColorManager.cd,
    indicatorSize: TabBarIndicatorSize.tab,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(AppColorManager.mainColor),
      foregroundColor: WidgetStatePropertyAll(AppColorManager.white),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0.r)),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: AppColorManager.secondColor,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0.r),
      borderSide: BorderSide(color: AppColorManager.secondColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0.r),
      borderSide: BorderSide(color: AppColorManager.secondColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0.r),
      borderSide: BorderSide(color: AppColorManager.secondColor, width: 3.0),
    ),
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: AppColorManager.white,
    scrimColor: AppColorManager.mainColor.withOpacity(0.3),
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(16.r),
        bottomRight: Radius.circular(16.r),
      ),
    ),
  ),
  shadowColor: AppColorManager.cd,
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
);

ThemeData get darkTheme => ThemeData(
  // textButtonTheme: TextButtonThemeData(
  //   style: ButtonStyle(
  //     backgroundColor: WidgetStateProperty.resolveWith<Color?>(
  //       (Set<WidgetState> states) {
  //         if (states.contains(WidgetState.disabled)) {
  //           return AppColorManager.darkColor.withValues(alpha: 0.5);
  //         }
  //         return AppColorManager.mainColor.withValues(alpha: 0.3);
  //       },
  //     ),
  //   ),
  // ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    borderRadius: BorderRadius.circular(8.0),
    linearMinHeight: 7.0,
    strokeCap: StrokeCap.round,
  ),
  primaryColorDark: Color(0xff13161D),
  dividerColor: Color(0xff4D5259),
  shadowColor: AppColorManager.darkColor.withValues(alpha: 0.5),
  listTileTheme: kDebugMode
      ? null
      : ListTileThemeData(
          horizontalTitleGap: 10.0,
          tileColor: Color(0xFF303030),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0.r)),
          controlAffinity: ListTileControlAffinity.leading,
        ),
  brightness: Brightness.dark,
  primaryColor: AppColorManager.secondColor,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColorManager.secondColor,
    selectionColor: AppColorManager.secondColor.withValues(alpha: 0.7),
    selectionHandleColor: AppColorManager.secondColor,
  ),
  scaffoldBackgroundColor: Color(0xff13161D),
  colorScheme: ColorScheme.dark(
    primary: AppColorManager.secondColor,
    secondary: AppColorManager.mainColorLight,
    surface: AppColorManager.tileColor,
    error: AppColorManager.red,
  ),
  fontFamily: appFontFamily,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColorManager.secondColor,
    foregroundColor: AppColorManager.darkColor,
  ),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: AppColorManager.darkColor,
    surfaceTintColor: AppColorManager.darkColor,
    iconTheme: IconThemeData(color: AppColorManager.secondColor),
    titleTextStyle: TextStyle(
      color: AppColorManager.white,
      fontFamily: appFontFamily,
      fontSize: 18.sp,
    ),
  ),
  cardColor: Color(0xFF303030),
  cardTheme: CardThemeData(
    color: Color(0xFF303030),
    elevation: 2,
    shadowColor: Colors.black38,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0.r)),
  ),
  tabBarTheme: TabBarThemeData(
    dividerColor: AppColorManager.darkColor,
    indicatorSize: TabBarIndicatorSize.tab,
  ),
  datePickerTheme: DatePickerThemeData(
    backgroundColor: AppColorManager.tileColor,
    headerBackgroundColor: AppColorManager.mainColor,
    headerForegroundColor: AppColorManager.white,
    confirmButtonStyle: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(AppColorManager.secondColor),
      foregroundColor: WidgetStatePropertyAll(AppColorManager.darkColor),
    ),
    cancelButtonStyle: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(AppColorManager.mainColor),
      foregroundColor: WidgetStatePropertyAll(AppColorManager.white),
    ),
    dayBackgroundColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorManager.secondColor;
        }
        return null;
      },
    ),
    dayForegroundColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorManager.darkColor;
        }
        return AppColorManager.white;
      },
    ),
    dayOverlayColor: WidgetStatePropertyAll(AppColorManager.secondColor),
    todayBackgroundColor: WidgetStatePropertyAll(AppColorManager.mainColorLight),
    todayForegroundColor: WidgetStatePropertyAll(AppColorManager.white),
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: AppColorManager.tileColor,
    hourMinuteTextColor: AppColorManager.white,
    confirmButtonStyle: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(AppColorManager.secondColor),
      foregroundColor: WidgetStatePropertyAll(AppColorManager.darkColor),
    ),
    cancelButtonStyle: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(AppColorManager.mainColor),
      foregroundColor: WidgetStatePropertyAll(AppColorManager.white),
    ),
    dialBackgroundColor: AppColorManager.mainColor,
    dialHandColor: AppColorManager.secondColor,
    dayPeriodColor: AppColorManager.mainColor,
    dayPeriodTextColor: AppColorManager.white,
    hourMinuteColor: AppColorManager.mainColor,
    timeSelectorSeparatorColor: WidgetStatePropertyAll(AppColorManager.secondColor),
    dayPeriodTextStyle: TextStyle(color: AppColorManager.white, fontSize: 14),
    dialTextStyle: TextStyle(color: AppColorManager.white, fontSize: 14),
    helpTextStyle: TextStyle(color: AppColorManager.secondColor, fontSize: 14),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(AppColorManager.secondColor),
      foregroundColor: WidgetStatePropertyAll(AppColorManager.darkColor),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0.r)),
      ),
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return AppColorManager.darkColor;
      return AppColorManager.mainColor;
    }),
    trackOutlineColor: WidgetStateProperty.resolveWith(
      (states) {
        return Colors.transparent;
      },
    ),
    trackColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorManager.secondColor;
        }
        return AppColorManager.mainColor;
      },
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: AppColorManager.tileColor,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0.r),
      borderSide: BorderSide(color: AppColorManager.secondColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0.r),
      borderSide: BorderSide(color: AppColorManager.mainColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0.r),
      borderSide: BorderSide(color: AppColorManager.secondColor),
    ),
    labelStyle: TextStyle(color: AppColorManager.white),
    hintStyle: TextStyle(color: AppColorManager.lightGrayAb),
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: AppColorManager.tileColor,
    scrimColor: AppColorManager.mainColor.withOpacity(0.5),
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(16.r),
        bottomRight: Radius.circular(16.r),
      ),
    ),
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      fontSize: 14.0.sp,
    ),
  ),
  dataTableTheme: DataTableThemeData(
    dataRowColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return AppColorManager.secondColor.withOpacity(0.2);
      }
      return null;
    }),
    dataTextStyle: TextStyle(
      color: AppColorManager.white,
      fontFamily: appFontFamily,
      fontSize: 14.sp,
    ),
    headingRowColor: WidgetStatePropertyAll(AppColorManager.mainColor),
    headingTextStyle: TextStyle(
      color: AppColorManager.white,
      fontFamily: appFontFamily,
      fontSize: 15.sp,
      fontWeight: FontWeight.bold,
    ),
    dividerThickness: 0,
    decoration: BoxDecoration(
      border: Border.all(color: AppColorManager.mainColor),
      borderRadius: BorderRadius.circular(8.0.r),
    ),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
);
