// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `About Us`
  String get aboutUs {
    return Intl.message('About Us', name: 'aboutUs', desc: '', args: []);
  }

  /// `Accepted`
  String get accepted {
    return Intl.message('Accepted', name: 'accepted', desc: '', args: []);
  }

  /// `and`
  String get and {
    return Intl.message('and', name: 'and', desc: '', args: []);
  }

  /// `ascending`
  String get ascending {
    return Intl.message('ascending', name: 'ascending', desc: '', args: []);
  }

  /// `Attach the back of the ID card here`
  String get attachIdBackHere {
    return Intl.message(
      'Attach the back of the ID card here',
      name: 'attachIdBackHere',
      desc: '',
      args: [],
    );
  }

  /// `Attach the front and back of the ID card:`
  String get attachIdFrontAndBack {
    return Intl.message(
      'Attach the front and back of the ID card:',
      name: 'attachIdFrontAndBack',
      desc: '',
      args: [],
    );
  }

  /// `Attach the front of the ID card here`
  String get attachIdFrontHere {
    return Intl.message(
      'Attach the front of the ID card here',
      name: 'attachIdFrontHere',
      desc: '',
      args: [],
    );
  }

  /// `Attach the back of the driving license here`
  String get attachLicenseBackHere {
    return Intl.message(
      'Attach the back of the driving license here',
      name: 'attachLicenseBackHere',
      desc: '',
      args: [],
    );
  }

  /// `Attach the front and back of the driving license:`
  String get attachLicenseFrontAndBack {
    return Intl.message(
      'Attach the front and back of the driving license:',
      name: 'attachLicenseFrontAndBack',
      desc: '',
      args: [],
    );
  }

  /// `Attach the front of the driving license here`
  String get attachLicenseFrontHere {
    return Intl.message(
      'Attach the front of the driving license here',
      name: 'attachLicenseFrontHere',
      desc: '',
      args: [],
    );
  }

  /// `Biometric Data`
  String get biometricData {
    return Intl.message(
      'Biometric Data',
      name: 'biometricData',
      desc: '',
      args: [],
    );
  }

  /// `birthday`
  String get birthday {
    return Intl.message('birthday', name: 'birthday', desc: '', args: []);
  }

  /// `Build Number`
  String get buildNumber {
    return Intl.message(
      'Build Number',
      name: 'buildNumber',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Cancelled`
  String get cancelled {
    return Intl.message('Cancelled', name: 'cancelled', desc: '', args: []);
  }

  /// `Car Color`
  String get carColor {
    return Intl.message('Car Color', name: 'carColor', desc: '', args: []);
  }

  /// `Car Model`
  String get carModel {
    return Intl.message('Car Model', name: 'carModel', desc: '', args: []);
  }

  /// `Car Name`
  String get carName {
    return Intl.message('Car Name', name: 'carName', desc: '', args: []);
  }

  /// `Cart`
  String get cart {
    return Intl.message('Cart', name: 'cart', desc: '', args: []);
  }

  /// `Change account`
  String get changeAccount {
    return Intl.message(
      'Change account',
      name: 'changeAccount',
      desc: '',
      args: [],
    );
  }

  /// `Change Passcode`
  String get changePasscode {
    return Intl.message(
      'Change Passcode',
      name: 'changePasscode',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Chassis Number`
  String get chassisNumber {
    return Intl.message(
      'Chassis Number',
      name: 'chassisNumber',
      desc: '',
      args: [],
    );
  }

  /// `Click To Update`
  String get clickToUpdate {
    return Intl.message(
      'Click To Update',
      name: 'clickToUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Enter Confirmation Code`
  String get confirmCode {
    return Intl.message(
      'Enter Confirmation Code',
      name: 'confirmCode',
      desc: '',
      args: [],
    );
  }

  /// `confirm New Password`
  String get confirmNewPassword {
    return Intl.message(
      'confirm New Password',
      name: 'confirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Congrats !`
  String get congrats {
    return Intl.message('Congrats !', name: 'congrats', desc: '', args: []);
  }

  /// `Continue`
  String get continueTo {
    return Intl.message('Continue', name: 'continueTo', desc: '', args: []);
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create New Account`
  String get createNewAccount {
    return Intl.message(
      'Create New Account',
      name: 'createNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Damage`
  String get damage {
    return Intl.message('Damage', name: 'damage', desc: '', args: []);
  }

  /// `day`
  String get day {
    return Intl.message('day', name: 'day', desc: '', args: []);
  }

  /// `I declare the authenticity of all information and files uploaded by me and assume full legal responsibility for any incorrect data.`
  String get declarationText {
    return Intl.message(
      'I declare the authenticity of all information and files uploaded by me and assume full legal responsibility for any incorrect data.',
      name: 'declarationText',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `descending`
  String get descending {
    return Intl.message('descending', name: 'descending', desc: '', args: []);
  }

  /// `Developed By`
  String get devBy {
    return Intl.message('Developed By', name: 'devBy', desc: '', args: []);
  }

  /// `Didn't Receive The OTP?`
  String get didNotReceiveOTP {
    return Intl.message(
      'Didn\'t Receive The OTP?',
      name: 'didNotReceiveOTP',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive the code?`
  String get didntReceiveTheCode {
    return Intl.message(
      'Didn\'t receive the code?',
      name: 'didntReceiveTheCode',
      desc: '',
      args: [],
    );
  }

  /// `Don't Have An Account?`
  String get doNotHaveAnAccount {
    return Intl.message(
      'Don\'t Have An Account?',
      name: 'doNotHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Done Pick`
  String get donePick {
    return Intl.message('Done Pick', name: 'donePick', desc: '', args: []);
  }

  /// `Done resend code`
  String get done_resend_code {
    return Intl.message(
      'Done resend code',
      name: 'done_resend_code',
      desc: '',
      args: [],
    );
  }

  /// `Driving License`
  String get drivingLicense {
    return Intl.message(
      'Driving License',
      name: 'drivingLicense',
      desc: '',
      args: [],
    );
  }

  /// `Driving License Info`
  String get drivingLicenseInfo {
    return Intl.message(
      'Driving License Info',
      name: 'drivingLicenseInfo',
      desc: '',
      args: [],
    );
  }

  /// `Edit Phone Number`
  String get editPhone {
    return Intl.message(
      'Edit Phone Number',
      name: 'editPhone',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Engine Capacity`
  String get engineCapacity {
    return Intl.message(
      'Engine Capacity',
      name: 'engineCapacity',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your OTP Code Here.`
  String get enterOTP {
    return Intl.message(
      'Enter Your OTP Code Here.',
      name: 'enterOTP',
      desc: '',
      args: [],
    );
  }

  /// `Enter the 6-digit code`
  String get enterThe6digitCode {
    return Intl.message(
      'Enter the 6-digit code',
      name: 'enterThe6digitCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone and password to log in.`
  String get enterYourPhoneAndPasswordToLogIn {
    return Intl.message(
      'Enter your phone and password to log in.',
      name: 'enterYourPhoneAndPasswordToLogIn',
      desc: '',
      args: [],
    );
  }

  /// `Enter expiry date`
  String get enterExpiryDate {
    return Intl.message(
      'Enter expiry date',
      name: 'enterExpiryDate',
      desc: '',
      args: [],
    );
  }

  /// `Expiry Date`
  String get expiryDate {
    return Intl.message('Expiry Date', name: 'expiryDate', desc: '', args: []);
  }

  /// `Favorites`
  String get fav {
    return Intl.message('Favorites', name: 'fav', desc: '', args: []);
  }

  /// `Forgot Password?`
  String get forgetPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fourName {
    return Intl.message('Full Name', name: 'fourName', desc: '', args: []);
  }

  /// `From`
  String get from {
    return Intl.message('From', name: 'from', desc: '', args: []);
  }

  /// `Fuel Type`
  String get fuelType {
    return Intl.message('Fuel Type', name: 'fuelType', desc: '', args: []);
  }

  /// `Gaz`
  String get gaz {
    return Intl.message('Gaz', name: 'gaz', desc: '', args: []);
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Governorate`
  String get governorate {
    return Intl.message('Governorate', name: 'governorate', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `hour`
  String get hour {
    return Intl.message('hour', name: 'hour', desc: '', args: []);
  }

  /// `Hybrid`
  String get hybrid {
    return Intl.message('Hybrid', name: 'hybrid', desc: '', args: []);
  }

  /// `I remembered my password`
  String get iRememberedMyPassword {
    return Intl.message(
      'I remembered my password',
      name: 'iRememberedMyPassword',
      desc: '',
      args: [],
    );
  }

  /// `I want to change account`
  String get iWantToChangeAccount {
    return Intl.message(
      'I want to change account',
      name: 'iWantToChangeAccount',
      desc: '',
      args: [],
    );
  }

  /// `ID Card Number`
  String get idCardNumber {
    return Intl.message(
      'ID Card Number',
      name: 'idCardNumber',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get info {
    return Intl.message('Info', name: 'info', desc: '', args: []);
  }

  /// `Intact`
  String get intact {
    return Intl.message('Intact', name: 'intact', desc: '', args: []);
  }

  /// `Required`
  String get is_required {
    return Intl.message('Required', name: 'is_required', desc: '', args: []);
  }

  /// `Issue Date`
  String get issueDate {
    return Intl.message('Issue Date', name: 'issueDate', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `latest`
  String get latest {
    return Intl.message('latest', name: 'latest', desc: '', args: []);
  }

  /// `License Type`
  String get licenseType {
    return Intl.message(
      'License Type',
      name: 'licenseType',
      desc: '',
      args: [],
    );
  }

  /// `Log in to your account`
  String get logInToYourAccount {
    return Intl.message(
      'Log in to your account',
      name: 'logInToYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Manage biometric settings for login.`
  String get manageBiometricSettings {
    return Intl.message(
      'Manage biometric settings for login.',
      name: 'manageBiometricSettings',
      desc: '',
      args: [],
    );
  }

  /// `Manage your driving license info.`
  String get manageDrivingLicenseInfo {
    return Intl.message(
      'Manage your driving license info.',
      name: 'manageDrivingLicenseInfo',
      desc: '',
      args: [],
    );
  }

  /// `Manage login passcode.`
  String get manageLoginPasscode {
    return Intl.message(
      'Manage login passcode.',
      name: 'manageLoginPasscode',
      desc: '',
      args: [],
    );
  }

  /// `Manage your cars and documents.`
  String get manageMyCars {
    return Intl.message(
      'Manage your cars and documents.',
      name: 'manageMyCars',
      desc: '',
      args: [],
    );
  }

  /// `Manage your phone number.`
  String get managePhoneNumber {
    return Intl.message(
      'Manage your phone number.',
      name: 'managePhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Manage your unified card data.`
  String get manageUnifiedCardInfo {
    return Intl.message(
      'Manage your unified card data.',
      name: 'manageUnifiedCardInfo',
      desc: '',
      args: [],
    );
  }

  /// `minute`
  String get minute {
    return Intl.message('minute', name: 'minute', desc: '', args: []);
  }

  /// `Missing`
  String get missing {
    return Intl.message('Missing', name: 'missing', desc: '', args: []);
  }

  /// `month`
  String get month {
    return Intl.message('month', name: 'month', desc: '', args: []);
  }

  /// `My Cars`
  String get myCars {
    return Intl.message('My Cars', name: 'myCars', desc: '', args: []);
  }

  /// `My Orders`
  String get myOrders {
    return Intl.message('My Orders', name: 'myOrders', desc: '', args: []);
  }

  /// `name`
  String get name {
    return Intl.message('name', name: 'name', desc: '', args: []);
  }

  /// `Need login`
  String get needLogin {
    return Intl.message('Need login', name: 'needLogin', desc: '', args: []);
  }

  /// `Need Pay`
  String get needPay {
    return Intl.message('Need Pay', name: 'needPay', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Please check your internet connection`
  String get noInternet {
    return Intl.message(
      'Please check your internet connection',
      name: 'noInternet',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notification {
    return Intl.message(
      'Notifications',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `notifications`
  String get notifications {
    return Intl.message(
      'notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Oops!`
  String get oops {
    return Intl.message('Oops!', name: 'oops', desc: '', args: []);
  }

  /// `Our service`
  String get ourService {
    return Intl.message('Our service', name: 'ourService', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Password field is required`
  String get passwordEmpty {
    return Intl.message(
      'Password field is required',
      name: 'passwordEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Password does not match`
  String get passwordNotMatch {
    return Intl.message(
      'Password does not match',
      name: 'passwordNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `There Is a Pending Phone Confirmation`
  String get pendingPhoneConfirmation {
    return Intl.message(
      'There Is a Pending Phone Confirmation',
      name: 'pendingPhoneConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Personal Data`
  String get personalData {
    return Intl.message(
      'Personal Data',
      name: 'personalData',
      desc: '',
      args: [],
    );
  }

  /// `Petrol`
  String get petrol {
    return Intl.message('Petrol', name: 'petrol', desc: '', args: []);
  }

  /// `Phone Data`
  String get phoneData {
    return Intl.message('Phone Data', name: 'phoneData', desc: '', args: []);
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Place of Residence`
  String get placeOfResidence {
    return Intl.message(
      'Place of Residence',
      name: 'placeOfResidence',
      desc: '',
      args: [],
    );
  }

  /// `Plate Number`
  String get plateNumber {
    return Intl.message(
      'Plate Number',
      name: 'plateNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please accept the declaration`
  String get pleaseAcceptDeclaration {
    return Intl.message(
      'Please accept the declaration',
      name: 'pleaseAcceptDeclaration',
      desc: '',
      args: [],
    );
  }

  /// `Please attach back ID image`
  String get pleaseAttachBackId {
    return Intl.message(
      'Please attach back ID image',
      name: 'pleaseAttachBackId',
      desc: '',
      args: [],
    );
  }

  /// `Please attach back license image`
  String get pleaseAttachBackLicense {
    return Intl.message(
      'Please attach back license image',
      name: 'pleaseAttachBackLicense',
      desc: '',
      args: [],
    );
  }

  /// `Please attach front ID image`
  String get pleaseAttachFrontId {
    return Intl.message(
      'Please attach front ID image',
      name: 'pleaseAttachFrontId',
      desc: '',
      args: [],
    );
  }

  /// `Please attach front license image`
  String get pleaseAttachFrontLicense {
    return Intl.message(
      'Please attach front license image',
      name: 'pleaseAttachFrontLicense',
      desc: '',
      args: [],
    );
  }

  /// `Please check the phone number. A verification code will be sent.`
  String get pleaseCheckPhoneNumber {
    return Intl.message(
      'Please check the phone number. A verification code will be sent.',
      name: 'pleaseCheckPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter address`
  String get pleaseEnterAddress {
    return Intl.message(
      'Please enter address',
      name: 'pleaseEnterAddress',
      desc: '',
      args: [],
    );
  }

  /// `Please enter full name`
  String get pleaseEnterFullName {
    return Intl.message(
      'Please enter full name',
      name: 'pleaseEnterFullName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter ID number`
  String get pleaseEnterIdNumber {
    return Intl.message(
      'Please enter ID number',
      name: 'pleaseEnterIdNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter license number`
  String get pleaseEnterLicenseNumber {
    return Intl.message(
      'Please enter license number',
      name: 'pleaseEnterLicenseNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter license type`
  String get pleaseEnterLicenseType {
    return Intl.message(
      'Please enter license type',
      name: 'pleaseEnterLicenseType',
      desc: '',
      args: [],
    );
  }

  /// `Please enter phone number`
  String get pleaseEnterPhoneNumber {
    return Intl.message(
      'Please enter phone number',
      name: 'pleaseEnterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please select birthday`
  String get pleaseSelectBirthday {
    return Intl.message(
      'Please select birthday',
      name: 'pleaseSelectBirthday',
      desc: '',
      args: [],
    );
  }

  /// `Please select expiry date`
  String get pleaseSelectExpiryDate {
    return Intl.message(
      'Please select expiry date',
      name: 'pleaseSelectExpiryDate',
      desc: '',
      args: [],
    );
  }

  /// `Please select gender`
  String get pleaseSelectGender {
    return Intl.message(
      'Please select gender',
      name: 'pleaseSelectGender',
      desc: '',
      args: [],
    );
  }

  /// `Please select issue date`
  String get pleaseSelectIssueDate {
    return Intl.message(
      'Please select issue date',
      name: 'pleaseSelectIssueDate',
      desc: '',
      args: [],
    );
  }

  /// `Please upload the inspection document (Al-Haza)`
  String get pleaseUploadInspectionDocument {
    return Intl.message(
      'Please upload the inspection document (Al-Haza)',
      name: 'pleaseUploadInspectionDocument',
      desc: '',
      args: [],
    );
  }

  /// `Preview file`
  String get previewFile {
    return Intl.message(
      'Preview file',
      name: 'previewFile',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `private`
  String get private {
    return Intl.message('private', name: 'private', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `public`
  String get public {
    return Intl.message('public', name: 'public', desc: '', args: []);
  }

  /// `Remember Me`
  String get rememberMe {
    return Intl.message('Remember Me', name: 'rememberMe', desc: '', args: []);
  }

  /// `Remember Password`
  String get rememberPassword {
    return Intl.message(
      'Remember Password',
      name: 'rememberPassword',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get resend {
    return Intl.message('Resend', name: 'resend', desc: '', args: []);
  }

  /// `Returned`
  String get returned {
    return Intl.message('Returned', name: 'returned', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Saved successfully`
  String get savedSuccessfully {
    return Intl.message(
      'Saved successfully',
      name: 'savedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `second`
  String get second {
    return Intl.message('second', name: 'second', desc: '', args: []);
  }

  /// `Sections`
  String get sections {
    return Intl.message('Sections', name: 'sections', desc: '', args: []);
  }

  /// `See All`
  String get see_all {
    return Intl.message('See All', name: 'see_all', desc: '', args: []);
  }

  /// `Send code`
  String get sendCode {
    return Intl.message('Send code', name: 'sendCode', desc: '', args: []);
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `سوف يتم حذف الحساب بجميع البيانات والكورسات`
  String get subTitleDeleteAccount {
    return Intl.message(
      'سوف يتم حذف الحساب بجميع البيانات والكورسات',
      name: 'subTitleDeleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get support {
    return Intl.message('Support', name: 'support', desc: '', args: []);
  }

  /// `Terms And Conditions`
  String get termsAndConditions {
    return Intl.message(
      'Terms And Conditions',
      name: 'termsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get to {
    return Intl.message('To', name: 'to', desc: '', args: []);
  }

  /// `Unified Card Info`
  String get unifiedCardInfo {
    return Intl.message(
      'Unified Card Info',
      name: 'unifiedCardInfo',
      desc: '',
      args: [],
    );
  }

  /// `update`
  String get update {
    return Intl.message('update', name: 'update', desc: '', args: []);
  }

  /// `Upload car inspection report`
  String get uploadInspectionReport {
    return Intl.message(
      'Upload car inspection report',
      name: 'uploadInspectionReport',
      desc: '',
      args: [],
    );
  }

  /// `Upload inspection report:`
  String get uploadInspectionReportTopic {
    return Intl.message(
      'Upload inspection report:',
      name: 'uploadInspectionReportTopic',
      desc: '',
      args: [],
    );
  }

  /// `Upload file (one file only)`
  String get uploadOneFileOnly {
    return Intl.message(
      'Upload file (one file only)',
      name: 'uploadOneFileOnly',
      desc: '',
      args: [],
    );
  }

  /// `Verification Code`
  String get verificationCode {
    return Intl.message(
      'Verification Code',
      name: 'verificationCode',
      desc: '',
      args: [],
    );
  }

  /// `verify`
  String get verify {
    return Intl.message('verify', name: 'verify', desc: '', args: []);
  }

  /// `We sent the reset verification code to`
  String get weSentTheResetVerificationCodeTo {
    return Intl.message(
      'We sent the reset verification code to',
      name: 'weSentTheResetVerificationCodeTo',
      desc: '',
      args: [],
    );
  }

  /// `Invalid phone number`
  String get wrongPhone {
    return Intl.message(
      'Invalid phone number',
      name: 'wrongPhone',
      desc: '',
      args: [],
    );
  }

  /// `Policy`
  String get policy {
    return Intl.message('Policy', name: 'policy', desc: '', args: []);
  }

  /// `Manage your phone number.`
  String get manageYourPhoneNumber {
    return Intl.message(
      'Manage your phone number.',
      name: 'manageYourPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Security Data`
  String get securityData {
    return Intl.message(
      'Security Data',
      name: 'securityData',
      desc: '',
      args: [],
    );
  }

  /// `Enter`
  String get enter {
    return Intl.message('Enter', name: 'enter', desc: '', args: []);
  }

  /// `Front`
  String get front {
    return Intl.message('Front', name: 'front', desc: '', args: []);
  }

  /// `Engine`
  String get engine {
    return Intl.message('Engine', name: 'engine', desc: '', args: []);
  }

  /// `Right`
  String get right {
    return Intl.message('Right', name: 'right', desc: '', args: []);
  }

  /// `Left`
  String get left {
    return Intl.message('Left', name: 'left', desc: '', args: []);
  }

  /// `Interior`
  String get interior {
    return Intl.message('Interior', name: 'interior', desc: '', args: []);
  }

  /// `Rear`
  String get rear {
    return Intl.message('Rear', name: 'rear', desc: '', args: []);
  }

  /// `Retake Image`
  String get retakeImage {
    return Intl.message(
      'Retake Image',
      name: 'retakeImage',
      desc: '',
      args: [],
    );
  }

  /// `Zain Cash`
  String get zainCash {
    return Intl.message('Zain Cash', name: 'zainCash', desc: '', args: []);
  }

  /// `Qi Card`
  String get qiCard {
    return Intl.message('Qi Card', name: 'qiCard', desc: '', args: []);
  }

  /// `Please upload inspection report`
  String get pleaseUploadInspectionReport {
    return Intl.message(
      'Please upload inspection report',
      name: 'pleaseUploadInspectionReport',
      desc: '',
      args: [],
    );
  }

  /// `Please enter car name`
  String get pleaseEnterCarName {
    return Intl.message(
      'Please enter car name',
      name: 'pleaseEnterCarName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter car color`
  String get pleaseEnterCarColor {
    return Intl.message(
      'Please enter car color',
      name: 'pleaseEnterCarColor',
      desc: '',
      args: [],
    );
  }

  /// `Please enter car model`
  String get pleaseEnterCarModel {
    return Intl.message(
      'Please enter car model',
      name: 'pleaseEnterCarModel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter chassis number`
  String get pleaseEnterChassisNumber {
    return Intl.message(
      'Please enter chassis number',
      name: 'pleaseEnterChassisNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter plate number`
  String get pleaseEnterPlateNumber {
    return Intl.message(
      'Please enter plate number',
      name: 'pleaseEnterPlateNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter engine capacity`
  String get pleaseEnterEngineCapacity {
    return Intl.message(
      'Please enter engine capacity',
      name: 'pleaseEnterEngineCapacity',
      desc: '',
      args: [],
    );
  }

  /// `Please select fuel type`
  String get pleaseSelectFuelType {
    return Intl.message(
      'Please select fuel type',
      name: 'pleaseSelectFuelType',
      desc: '',
      args: [],
    );
  }

  /// `Please select start date`
  String get pleaseSelectStartDate {
    return Intl.message(
      'Please select start date',
      name: 'pleaseSelectStartDate',
      desc: '',
      args: [],
    );
  }

  /// `Please select end date`
  String get pleaseSelectEndDate {
    return Intl.message(
      'Please select end date',
      name: 'pleaseSelectEndDate',
      desc: '',
      args: [],
    );
  }

  /// `Please attach front ownership image`
  String get pleaseUploadOwnershipFrontImage {
    return Intl.message(
      'Please attach front ownership image',
      name: 'pleaseUploadOwnershipFrontImage',
      desc: '',
      args: [],
    );
  }

  /// `Please attach back ownership image`
  String get pleaseUploadOwnershipBackImage {
    return Intl.message(
      'Please attach back ownership image',
      name: 'pleaseUploadOwnershipBackImage',
      desc: '',
      args: [],
    );
  }

  /// `Please take a front image`
  String get pleaseTakeFrontImage {
    return Intl.message(
      'Please take a front image',
      name: 'pleaseTakeFrontImage',
      desc: '',
      args: [],
    );
  }

  /// `Please take an engine image`
  String get pleaseTakeEngineImage {
    return Intl.message(
      'Please take an engine image',
      name: 'pleaseTakeEngineImage',
      desc: '',
      args: [],
    );
  }

  /// `Please take a right side image`
  String get pleaseTakeRightSideImage {
    return Intl.message(
      'Please take a right side image',
      name: 'pleaseTakeRightSideImage',
      desc: '',
      args: [],
    );
  }

  /// `Please take a left side image`
  String get pleaseTakeLeftSideImage {
    return Intl.message(
      'Please take a left side image',
      name: 'pleaseTakeLeftSideImage',
      desc: '',
      args: [],
    );
  }

  /// `Please take an interior image`
  String get pleaseTakeInteriorImage {
    return Intl.message(
      'Please take an interior image',
      name: 'pleaseTakeInteriorImage',
      desc: '',
      args: [],
    );
  }

  /// `Please take a rear image`
  String get pleaseTakeRearImage {
    return Intl.message(
      'Please take a rear image',
      name: 'pleaseTakeRearImage',
      desc: '',
      args: [],
    );
  }

  /// `Please select the status of all car parts`
  String get pleaseCompleteAllInspectionFields {
    return Intl.message(
      'Please select the status of all car parts',
      name: 'pleaseCompleteAllInspectionFields',
      desc: '',
      args: [],
    );
  }

  /// `Your account has been successfully created. You will now be redirected to the home screen.`
  String get yourAccountHasBeenSuccessfullyCreatedYouWillNowBe {
    return Intl.message(
      'Your account has been successfully created. You will now be redirected to the home screen.',
      name: 'yourAccountHasBeenSuccessfullyCreatedYouWillNowBe',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
