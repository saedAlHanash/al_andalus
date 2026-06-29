

class Adss {
  Adss({
    required this.data,
  });

  final List<Ads> data;

  factory Adss.fromJson(Map<String, dynamic> json) {
    return Adss(
      data: json["data"] == null ? [] : List<Ads>.from(json["data"]!.map((x) => Ads.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class Ads {
  Ads({
    required this.id,
    required this.title,
    required this.image,
    required this.type,
  });

  final int id;
  final String title;
  final String image;
  final String type;

  factory Ads.fromJson(Map<String, dynamic> json) {
    return Ads(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      image: json["image"] ?? "",
      type: (json["type"] ?? "").toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "type": type,
  };
}
