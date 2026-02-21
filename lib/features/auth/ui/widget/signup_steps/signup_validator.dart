import 'package:flutter/material.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../../core/util/snack_bar_message.dart';
import '../../../../../generated/l10n.dart';
import '../../../data/request/signup_request.dart';

class SignupValidator {
  static bool validateStep(BuildContext context, int step, SignupRequest request) {
    if (step == 0) return _validateStep0(context, request);
    if (step == 1) return _validateStep1(context, request);
    if (step == 2) return _validateStep2(context, request);
    return true;
  }

  static bool _validateStep0(BuildContext context, SignupRequest request) {
    if (request.identityId.isBlank) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseEnterIdNumber, context: context);
      return false;
    }
    if (request.name.isBlank ) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseEnterFullName, context: context);
      return false;
    }
    if (request.address.isBlank ) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseEnterAddress, context: context);
      return false;
    }
    if (request.birthday == null) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseSelectBirthday, context: context);
      return false;
    }
    if (request.gender == null) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseSelectGender, context: context);
      return false;
    }
    if (request.identityFrontImage.fileBytes == null) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseAttachFrontId, context: context);
      return false;
    }
    if (request.identityBackImage.fileBytes == null) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseAttachBackId, context: context);
      return false;
    }
    if (!request.infoChecked) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseAcceptDeclaration, context: context);
      return false;
    }
    return true;
  }

  static bool _validateStep1(BuildContext context, SignupRequest request) {
    if (request.licenseNumber.isBlank ) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseEnterLicenseNumber, context: context);
      return false;
    }
    if (request.licenseType == null) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseEnterLicenseType, context: context);
      return false;
    }
    if (request.licenseStartDate == null) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseSelectIssueDate, context: context);
      return false;
    }
    if (request.licenseEndDate == null) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseSelectExpiryDate, context: context);
      return false;
    }
    if (request.licenseFrontImage.fileBytes == null) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseAttachFrontLicense, context: context);
      return false;
    }
    if (request.licenseBackImage.fileBytes == null) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseAttachBackLicense, context: context);
      return false;
    }
    if (!request.licenseChecked) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseAcceptDeclaration, context: context);
      return false;
    }
    return true;
  }

  static bool _validateStep2(BuildContext context, SignupRequest request) {
    if (request.phone.isBlank) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseEnterPhoneNumber, context: context);
      return false;
    }
    return true;
  }
}
