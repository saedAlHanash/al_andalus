import '../response/policy_response.dart';

class CreatePolicyRequest {
  CreatePolicyRequest({
    required this.id,
  });

  final String id;

  factory CreatePolicyRequest.fromJson(Map<String, dynamic> json) {
    return CreatePolicyRequest(
      id: json["id"] ?? "",
    );
  }

  factory CreatePolicyRequest.fromPolicy(Policy policy) {
    return CreatePolicyRequest(
      id: policy.id,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}
