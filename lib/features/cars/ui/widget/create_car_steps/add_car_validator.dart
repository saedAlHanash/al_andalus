import 'package:flutter/material.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../../core/util/snack_bar_message.dart';
import '../../../../../generated/l10n.dart';
import '../../../data/request/insurance_policy_request.dart';

class AddCarValidator {
  static bool validateStep(BuildContext context, int step, InsurancePolicyRequest request) {
    if (step == 0) return _validateStep0(context, request);
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
      NoteMessage.showTopMessageError(message: S.of(context).pleaseTakeEngineImage, context: context);
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
      NoteMessage.showTopMessageError(message: S.of(context).pleaseTakeRearImage, context: context);
      return false;
    }
    return true;
  }

  static bool _validateStep4(BuildContext context, InsurancePolicyRequest request) {
    return true;
  }
}

bool _validate(BuildContext context, InsurancePolicyRequest request) {
  if (request.metalBody != .intact && request.metalBodyNote.isBlank) {
    NoteMessage.showTopMessageError(
      message: 'يجب إضافة ملاحظة لهيكل المعدن',
      context: context,
    );
    return false;
  }

  if (request.glassAndLamps != .intact && request.glassAndLampsNote.isBlank) {
    NoteMessage.showTopMessageError(
      message: 'يجب إضافة ملاحظة للزجاج والمصابيح',
      context: context,
    );
    return false;
  }

  if (request.chromeNickel != .intact && request.chromeNickelNote.isBlank) {
    NoteMessage.showTopMessageError(
      message: 'يجب إضافة ملاحظة للكروم والنيكل',
      context: context,
    );
    return false;
  }

  if (request.brandSign != .intact && request.brandSignNote.isBlank) {
    NoteMessage.showTopMessageError(
      message: 'يجب إضافة ملاحظة لشعار السيارة',
      context: context,
    );
    return false;
  }

  if (request.windshieldWipers != .intact && request.windshieldWipersNote.isBlank) {
    NoteMessage.showTopMessageError(
      message: 'يجب إضافة ملاحظة لمسّاحات الزجاج',
      context: context,
    );
    return false;
  }

  if (request.radioAntenna != .intact && request.radioAntennaNote.isBlank) {
    NoteMessage.showTopMessageError(
      message: 'يجب إضافة ملاحظة لهوائي الراديو',
      context: context,
    );
    return false;
  }

  if (request.seats != .intact && request.seatsNote.isBlank) {
    NoteMessage.showTopMessageError(
      message: 'يجب إضافة ملاحظة للمقاعد',
      context: context,
    );
    return false;
  }

  if (request.floorCover != .intact && request.floorCoverNote.isBlank) {
    NoteMessage.showTopMessageError(
      message: 'يجب إضافة ملاحظة لغطاء الأرضية',
      context: context,
    );
    return false;
  }

  if (request.radio != .intact && request.radioNote.isBlank) {
    NoteMessage.showTopMessageError(
      message: 'يجب إضافة ملاحظة للراديو',
      context: context,
    );
    return false;
  }

  if (request.airConditioner != .intact && request.airConditionerNote.isBlank) {
    NoteMessage.showTopMessageError(
      message: 'يجب إضافة ملاحظة للمكيف',
      context: context,
    );
    return false;
  }

  if (request.frontTires != .intact && request.frontTiresNote.isBlank) {
    NoteMessage.showTopMessageError(
      message: 'يجب إضافة ملاحظة للإطارات الأمامية',
      context: context,
    );
    return false;
  }

  if (request.backTires != .intact && request.backTiresNote.isBlank) {
    NoteMessage.showTopMessageError(
      message: 'يجب إضافة ملاحظة للإطارات الخلفية',
      context: context,
    );
    return false;
  }

  if (request.spareTire != .intact && request.spareTireNote.isBlank) {
    NoteMessage.showTopMessageError(
      message: 'يجب إضافة ملاحظة للإطار الاحتياطي',
      context: context,
    );
    return false;
  }

  if (request.tiresCovers != .intact && request.tiresCoversNote.isBlank) {
    NoteMessage.showTopMessageError(
      message: 'يجب إضافة ملاحظة لأغطية الإطارات',
      context: context,
    );
    return false;
  }

  if (request.spareTools != .intact && request.spareToolsNote.isBlank) {
    NoteMessage.showTopMessageError(
      message: 'يجب إضافة ملاحظة لأدوات الاحتياط',
      context: context,
    );
    return false;
  }

  return true;
}
