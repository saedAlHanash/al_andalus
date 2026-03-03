import 'package:al_andalus/core/util/snack_bar_message.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../generated/l10n.dart';

import '../../../data/request/accident_request.dart';

class AddAccidentValidator {
  static bool validateStep(BuildContext context, int step, AccidentRequest request) {
    if (step == 0) {
      if (request.vehicleId == null || request.vehicleId!.isEmpty) {
        NoteMessage.showSnakeBar(message: S.of(context).pleaseEnterVehicleId, context: context);
        return false;
      }
      if (request.location == null || request.location!.isEmpty) {
        NoteMessage.showSnakeBar(message: S.of(context).pleaseEnterLocation, context: context);
        return false;
      }
      if (request.description == null || request.description!.isEmpty) {
        NoteMessage.showSnakeBar(message: S.of(context).pleaseEnterDescription, context: context);
        return false;
      }
    }

    if (step == 1) {
      if (request.policeReport.notHaveValue) {
        NoteMessage.showSnakeBar(message: S.of(context).pleaseUploadPoliceReport, context: context);
        return false;
      }
      if (request.frontImage.notHaveValue ||
          request.backImage.notHaveValue ||
          request.rightSideImage.notHaveValue ||
          request.leftSideImage.notHaveValue ||
          request.interiorImage.notHaveValue ||
          request.engineImage.notHaveValue) {
        NoteMessage.showSnakeBar(message: S.of(context).pleaseUploadAllImages, context: context);
        return false;
      }
    }

    return true;
  }
}
