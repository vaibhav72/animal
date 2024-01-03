class Bear {
  String createdAt;
  String animalName;
  String type;
  String id;

  Bear({
    required this.createdAt,
    required this.animalName,
    required this.type,
    required this.id,
  });

  factory Bear.fromJson(Map<String, dynamic> json) {
    return Bear(
      createdAt: json['createdAt'],
      animalName: json['animalName'],
      type: json['type'],
      id: json['id'],
    );
  }
}
