class Policy {
  Policy({
    required this.id,
    required this.data,
  });

   String id;
  final String data;


  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "data": data,
    };
  }

  factory Policy.fromJson(Map<String, dynamic> json) {
    return Policy(
      id: json["id"] ?? "",
      data: json["data"] ?? "",
    );
  }
}

