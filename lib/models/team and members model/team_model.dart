class TeamModel {
  final int id;
  final String name;
  final String description;
  final List<int> farms;
  final String? manager;
  final DateTime createdAt;

  TeamModel({
    required this.id,
    required this.name,
    required this.description,
    required this.farms,
    this.manager,
    required this.createdAt,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      farms: List<int>.from(json['farms']),
      manager: json['manager'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'farms': farms,
      'manager': manager,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
