class UserInfo {
  final String name;
  final String role;
  final String pictureUrl;
  final String selectedFarm;
  final bool showAds;

  UserInfo({
    required this.name,
    required this.role,
    required this.pictureUrl,
    required this.showAds,
    this.selectedFarm = "None", // Default value
  });

  // Add copyWith method for immutability
  UserInfo copyWith({
    String? name,
    String? role,
    String? pictureUrl,
    String? selectedFarm,
    bool? showAds,
  }) {
    return UserInfo(
      name: name ?? this.name,
      role: role ?? this.role,
      showAds: showAds ?? this.showAds,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      selectedFarm: selectedFarm ?? this.selectedFarm,
    );
  }
}