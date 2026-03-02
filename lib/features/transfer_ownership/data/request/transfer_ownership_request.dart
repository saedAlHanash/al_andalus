import '../../../../core/api_manager/api_service.dart';

class TransferOwnershipRequest {
  TransferOwnershipRequest({
    this.policyId,
    this.newOwnerName,
    this.newOwnerPhone,
    this.newOwnerIdentityNumber,
  });

  int? policyId;
  String? newOwnerName;
  String? newOwnerPhone;
  String? newOwnerIdentityNumber;

  // Files
  var identityFrontImage = UploadFile(nameField: 'identity_front_image');
  var identityBackImage = UploadFile(nameField: 'identity_back_image');

  List<UploadFile> get files => [
    identityFrontImage..nameField = 'identity_front_image',
    identityBackImage..nameField = 'identity_back_image',
  ];

  Map<String, dynamic> toJson() => {
    'policy_id': policyId,
    'new_owner_name': newOwnerName,
    'new_owner_phone': newOwnerPhone,
    'new_owner_identity_number': newOwnerIdentityNumber,
  };
}
