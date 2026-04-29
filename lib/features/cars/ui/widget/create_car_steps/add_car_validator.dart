import 'package:flutter/material.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../../core/strings/enum_manager.dart';
import '../../../../../core/util/snack_bar_message.dart';
import '../../../../../generated/l10n.dart';
import '../../../data/request/insurance_policy_request.dart';

class AddCarValidator {
  static bool validateStep(BuildContext context, int step, InsurancePolicyRequest request) {
    // if (step == 0) return _validateStep0(context, request);
    if (step == 1) return _validateStep1(context, request);
    if (step == 2) return _validateStep2(context, request);
    if (step == 3) return _validateStep3(context, request);
    if (step == 4) return _validateStep4(context, request);
    return true;
  }

  static bool _validateStep0(BuildContext context, InsurancePolicyRequest request) {
    if (request.inspectionReport.notHaveValue) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseUploadInspectionReport, context: context);
      return false;
    }
    return true;
  }

  static bool _validateStep1(BuildContext context, InsurancePolicyRequest request) {
    if (request.name.isBlank) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseEnterCarName, context: context);
      return false;
    }
    if (request.color.isBlank) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseEnterCarColor, context: context);
      return false;
    }
    if (request.brand.isBlank) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseEnterCarModel, context: context);
      return false;
    }
    if (request.chassisNumber.isBlank) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseEnterChassisNumber, context: context);
      return false;
    }
    if (request.plateNumber.isBlank) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseEnterPlateNumber, context: context);
      return false;
    }
    if (request.engineCapacity.isBlank) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseEnterEngineCapacity, context: context);
      return false;
    }
    if (request.fuelType == null) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseSelectFuelType, context: context);
      return false;
    }
    if (request.expiryStartDate == null) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseSelectStartDate, context: context);
      return false;
    }
    if (request.expiryEndDate == null) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseSelectEndDate, context: context);
      return false;
    }
    if (request.manufactureYear == null) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseSelectManufactureYear, context: context);
      return false;
    }
    if (request.ownershipFrontImage.notHaveValue) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseUploadOwnershipFrontImage, context: context);
      return false;
    }
    if (request.ownershipBackImage.notHaveValue) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseUploadOwnershipBackImage, context: context);
      return false;
    }
    if (!request.annualInfoCheck) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseAcceptDeclaration, context: context);
      return false;
    }
    return true;
  }

  static bool _validateStep2(BuildContext context, InsurancePolicyRequest request) {
    if (request.metalBody == null ||
        request.glassAndLamps == null ||
        request.chromeNickel == null ||
        request.brandSign == null ||
        request.windshieldWipers == null ||
        request.radioAntenna == null ||
        request.seats == null ||
        request.floorCover == null ||
        request.radio == null ||
        request.airConditioner == null ||
        request.frontTires == null ||
        request.backTires == null ||
        request.spareTire == null ||
        request.tiresCovers == null ||
        request.spareTools == null) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseCompleteAllInspectionFields, context: context);
      return false;
    }

    if (!_validate(context, request)) return false;

    if (!request.carPreviewInfoCheck) {
      NoteMessage.showTopMessageError(message: S.of(context).pleaseAcceptDeclaration, context: context);
      return false;
    }
    return true;
  }

  static bool _validateStep3(BuildContext context, InsurancePolicyRequest request) {
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
    return true;
  }

  static bool _validateStep4(BuildContext context, InsurancePolicyRequest request) {
    return true;
  }

  static bool _validate(BuildContext context, InsurancePolicyRequest request) {
    final s = S.of(context);

    final fields = [
      (request.metalBody, request.metalBodyNote, s.metalBody),
      (request.glassAndLamps, request.glassAndLampsNote, s.glassAndLamps),
      (request.chromeNickel, request.chromeNickelNote, s.chromeNickel),
      (request.brandSign, request.brandSignNote, s.brandSign),
      (request.windshieldWipers, request.windshieldWipersNote, s.windshieldWipers),
      (request.radioAntenna, request.radioAntennaNote, s.radioAntenna),
      (request.seats, request.seatsNote, s.seats),
      (request.floorCover, request.floorCoverNote, s.floorCover),
      (request.radio, request.radioNote, s.radioAndType),
      (request.airConditioner, request.airConditionerNote, s.airConditionerAndType),
      (request.frontTires, request.frontTiresNote, s.frontTires),
      (request.backTires, request.backTiresNote, s.backTires),
      (request.spareTire, request.spareTireNote, s.spareTire),
      (request.tiresCovers, request.tiresCoversNote, s.tiresCovers),
      (request.spareTools, request.spareToolsNote, s.spareTools),
    ];

    for (final field in fields) {
      if (field.$1 != InspectionStatus.intact && (field.$2).isBlank) {
        NoteMessage.showTopMessageError(
          message: s.noteIsRequired(field.$3),
          context: context,
        );
        return false;
      }
    }

    return true;
  }
}

