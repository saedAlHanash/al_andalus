import 'package:al_andalus/core/strings/enum_manager.dart';

import '../../../../core/api_manager/api_service.dart';

class TransferOwnershipRequest {
  TransferOwnershipRequest({
    this.qrcode,
    this.paymentType,
  });

  int? qrcode;
  PaymentType? paymentType;

  bool get canSend => qrcode != null && paymentType != null;

  Map<String, dynamic> toJson() => {
    'qrcode': qrcode,
    'payment_type': paymentType?.nameApi,
  };
}
