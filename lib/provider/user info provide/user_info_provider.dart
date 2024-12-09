import 'package:aiponics_web_app/models/user%20info%20model/user_info_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInfoNotifier extends StateNotifier<UserInfo> {
  UserInfoNotifier()
      : super(UserInfo(
    name: "Default User",
    role: "operator",
    pictureUrl: "assets/images/logo.jpeg",
    showAds: true
  ));

  // Update the user's name
  void updateName(String newName) {
    state = state.copyWith(name: newName);
  }

  // Update the user's role
  void updateRole(String newRole) {
    state = state.copyWith(role: newRole);
  }

  // Update the user's picture
  void updatePicture(String newPictureUrl) {
    state = state.copyWith(pictureUrl: newPictureUrl);
  }

  // Update the user's selected farm
  void updateFarm(String newFarm) {
    state = state.copyWith(selectedFarm: newFarm);
  }

  // Update the user's selected farm
  void updateAdsStatus(bool showAds) {
    state = state.copyWith(showAds: showAds);
  }

  // Batch update for all user info fields
  void updateUserInfo({
    required String newName,
    required String newRole,
    required String newPictureUrl,
  }) {
    state = state.copyWith(
      name: newName,
      role: newRole,
      pictureUrl: newPictureUrl,
    );
  }
}

final userInfoProvider =
StateNotifierProvider<UserInfoNotifier, UserInfo>((ref) {
  return UserInfoNotifier();
});
