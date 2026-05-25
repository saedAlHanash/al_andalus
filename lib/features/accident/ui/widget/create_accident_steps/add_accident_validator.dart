import 'package:flutter/material.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../../core/util/snack_bar_message.dart';
import '../../../../../generated/l10n.dart';
import '../../../data/request/accident_request.dart';

class AddAccidentValidator {
  static bool validateStep(BuildContext context, int step, AccidentRequest request) {
    if (step == 0) {
      if (request.vehicleId.isBlank) {
        NoteMessage.showTopMessageError(message: S.of(context).pleaseEnterVehicleId, context: context);
        return false;
      }
      if (request.description.isBlank) {
        NoteMessage.showTopMessageError(message: S.of(context).pleaseEnterDescription, context: context);
        return false;
      }
      if (request.location.isBlank) {
        NoteMessage.showTopMessageError(message: S.of(context).pleaseEnterLocation, context: context);
        return false;
      }
      if (request.policeReport.notHaveValue) {
        NoteMessage.showTopMessageError(message: S.of(context).pleaseUploadPoliceReport, context: context);
        return false;
      }
    }

    if (step == 1) {
      if (request.frontImage.notHaveValue) {
        NoteMessage.showTopMessageError(message: S.of(context).pleaseTakeFrontImage, context: context);
        return false;
      }
      if (request.backImage.notHaveValue) {
        NoteMessage.showTopMessageError(message: S.of(context).pleaseTakeRearImage, context: context);
        return false;
      }
      if (request.rightSideImage.notHaveValue) {
        NoteMessage.showTopMessageError(message: S.of(context).pleaseTakeRightSideImage, context: context);
        return false;
      }
      if (request.leftSideImage.notHaveValue) {
        NoteMessage.showTopMessageError(message: S.of(context).pleaseTakeLeftSideImage, context: context);
        return false;
      }
      if (request.interiorImage.notHaveValue) {
        NoteMessage.showTopMessageError(message: S.of(context).pleaseTakeInteriorImage, context: context);
        return false;
      }
      if (request.engineImage.notHaveValue) {
        NoteMessage.showTopMessageError(message: S.of(context).pleaseTakeEngineImage, context: context);
        return false;
      }
    }

    return true;
  }
}
