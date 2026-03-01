class AccidentResponse {
  final int id;
  final String name;

  AccidentResponse({
    required this.id,
    required this.name,
  });

  factory AccidentResponse.fromJson(Map<String, dynamic> json) {
    return AccidentResponse(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}

class AccidentListResponse {
  final List<AccidentResponse> data;

  AccidentListResponse({required this.data});

  factory AccidentListResponse.fromJson(Map<String, dynamic> json) {
    return AccidentListResponse(
      data: (json['data'] as List?)?.map((e) => AccidentResponse.fromJson(e)).toList() ?? [],
    );
  }
}
