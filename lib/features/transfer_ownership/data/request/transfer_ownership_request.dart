import 'package:al_andalus/core/strings/enum_manager.dart';

class TransferOwnershipRequest {
  TransferOwnershipRequest({
    this.qrcode,
    this.paymentType,
  });

  String? qrcode;
  PaymentType? paymentType;

  bool get canSend => qrcode != null && paymentType != null;

  Map<String, dynamic> toJson() => {
    'qrcode': qrcode,
    'payment_type': paymentType?.nameApi,
  };
}
