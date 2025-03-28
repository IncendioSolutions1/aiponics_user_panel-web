class TeamMemberModel {
  final int id;
  final int user;
  final int team;
  final String role;
  final DateTime joinedDate;
  final bool isActive;
  final bool isApprovedByAdmin;
  final String? profilePhoto;

  TeamMemberModel({
    required this.id,
    required this.user,
    required this.team,
    required this.role,
    required this.joinedDate,
    required this.isActive,
    required this.isApprovedByAdmin,
    this.profilePhoto,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      id: json['id'],
      user: json['user'],
      team: json['team'],
      role: json['role'],
      joinedDate: DateTime.parse(json['joined_date']),
      isActive: json['is_active'],
      isApprovedByAdmin: json['is_approved_by_admin'],
      profilePhoto: json['profile_photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'team': team,
      'role': role,
      'joined_date': joinedDate.toIso8601String(),
      'is_active': isActive,
      'is_approved_by_admin': isApprovedByAdmin,
      'profile_photo': profilePhoto,
    };
  }
}
