import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/profile/data/response/profile_response.dart';
import '../strings/enum_manager.dart';

class AppSharedPreference {
  //region Keys
  static const _token = '1';
  static const _phone = '2';
  static const _fireToken = '3';
  static const _lang = '4';
  static const _screenType = '5';
  static const _user = '6';
  static const _notifications = '7';
  static const _notificationCount = '8';
  static const _testIosFromServer = '9';
  static const _resendTime = '10';
  static const _isLoginToChatApp = '11';
  static const _hasSeenIntro = '13';
  static const _keyThemeMode = '_keyThemeMode';
  static const _unconfirmedPhone = '_unconfirmedPhone';
  static const tempToken = 'tempToken';

  //endregion

  //region Core
  static SharedPreferences? _prefs;

  static bool get isInitial => _prefs != null;

  static init(SharedPreferences preferences) => _prefs = preferences;

  static reload() async => await _prefs?.reload();

  //endregion

  //region Token
  static Future<void> cashToken(String? token) async {
    if (token == null) return;
    await _prefs?.setString(_token, token);
  }

  static String get getToken => _prefs?.getString(_token) ?? '';

  //endregion

  //region Email
  static Future<void> cashPhone(String? phone) async {
    if (phone == null) return;
    await _prefs?.setString(_phone, phone);
  }

  static String get getPhone => _prefs?.getString(_phone) ?? '';

  static Future<void> removePhone() async {
    await _prefs?.remove(_phone);
  }

  //endregion

  //region Unconfirmed Phone
  static Future<void> cashUnconfirmedPhone(String? phone) async {
    if (phone == null) return;
    await _prefs?.setString(_unconfirmedPhone, phone);
  }

  static String get getUnconfirmedPhone => _prefs?.getString(_unconfirmedPhone) ?? '';

  static Future<void> removeUnconfirmedPhone() async {
    await _prefs?.remove(_unconfirmedPhone);
  }
  //endregion

  //region User
  static Future<void> cashUser(Profile user) async {
    final json = user.toJson();
    await _prefs?.setString(_user, jsonEncode(json));
  }

  static Profile get getUser => Profile.fromJson(jsonDecode(_prefs?.getString(_user) ?? '{}'));

  //endregion

  //region FireToken
  static void cashFireToken(String token) {
    _prefs?.setString(_fireToken, token);
  }

  static String get getFireToken => _prefs?.getString(_fireToken) ?? '';

  //endregion

  //region Language
  static Future<void> cashLocal(String langCode) async {
    await _prefs?.setString(_lang, langCode);
  }

  static String get getLocal => _prefs?.getString(_lang) ?? 'ar';

  //endregion

  //region StartPage
  static Future<void> cashStartPage(StartPage type) async {
    await _prefs?.setInt(_screenType, type.index);
  }

  static StartPage get getStartPage => StartPage.values[_prefs?.getInt(_screenType) ?? 0];

  //endregion

  //region Notifications
  static void cashNotificationState(bool n) {
    _prefs?.setBool(_notifications, n);
  }

  static bool get getNotificationState => _prefs?.getBool(_notifications) ?? true;

  static void addNotificationCount() {
    var count = getNotificationCount() + 1;
    _prefs?.setInt(_notificationCount, count);
  }

  static int getNotificationCount() {
    return _prefs?.getInt(_notificationCount) ?? 0;
  }

  static void clearNotificationCount() {
    _prefs?.setInt(_notificationCount, 0);
  }

  //endregion

  //region ChatApp
  static void cashLoginToChatApp(bool b) {
    _prefs?.setBool(_isLoginToChatApp, b);
  }

  static bool get getIsLoginToChatApp => _prefs?.getBool(_isLoginToChatApp) ?? false;

  //endregion

  //region TestIos
  static void changeTestIosFromServer(bool state) {
    _prefs?.setBool(_testIosFromServer, state);
  }

  //endregion

  //region ResendTime
  static Future<void> setResendDateTime(int s) async {
    final d = DateTime.now().add(Duration(seconds: s));
    await _prefs?.setString(_resendTime, d.toIso8601String());
  }

  static DateTime get getResendDateTime => DateTime.tryParse(_prefs?.getString(_resendTime) ?? '') ?? DateTime.now();

  //endregion

  //region Intro
  static Future<void> setHasSeenIntro(bool value) async {
    await _prefs?.setBool(_hasSeenIntro, value);
  }

  static bool get hasSeenIntro => _prefs?.getBool(_hasSeenIntro) ?? false;

  //endregion

  //region Clear/Logout
  static Future<void> clear() async => await _prefs?.clear();

  static Future<void> logout() async => await _prefs?.clear();

  //endregion

  //region ThemeMode
  static Future<void> cashThemeMode(ThemeMode themeMode) async {
    await _prefs?.setInt(_keyThemeMode, themeMode.index);
  }

  static ThemeMode get getThemeMode => ThemeMode.values[_prefs?.getInt(_keyThemeMode) ?? 1];

  //endregion

  //region FontName
  static const _keyFontName = '_keyFontName';

  static Future<void> cashFontName(String fontName) async {
    await _prefs?.setString(_keyFontName, fontName);
  }

  static String get getFontName => _prefs?.getString(_keyFontName) ?? 'Cairo';

  //endregion
}
