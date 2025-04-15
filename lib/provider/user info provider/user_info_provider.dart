import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/user info controller/user_account_controller.dart';
import '../../models/user info model/user_info_model.dart';

class UserAccountNotifier extends StateNotifier<UserAccount> {
  UserAccountNotifier()
      : super(UserAccount(
    userAccountInfoModel: UserAccountInfoModel(
      id: 0,
      password: "",
      lastLogin: null,
      isSuperuser: false,
      username: "loading",
      isStaff: false,
      isActive: false,
      dateJoined: DateTime.now(),
      email: "",
      firstName: "Loading Name",
      lastName: "",
      phoneNumber: null,
      profilePicture: null,
      address: null,
      subscriptionStart: null,
      subscriptionEnd: null,
      isActiveSubscription: false,
      lastPaymentDate: null,
      registeredDate: DateTime.now(),
      role: ["Loading Role"],
      plan: 0,
      groups: [],
      userPermissions: [],
    ),
    isLoading: true,
    hasError: false,
  )) {
    // Automatically check for a "null" state on every state update.
    addListener(_autoFetchOnNull);

    // Initial fetch if state is "null" and not already loading.
    if (isNull()) {
      fetchUserInfo();
    }
  }

  /// Returns true if the current user state is “null” or empty.
  bool isNull() {
    return state.userAccountInfoModel.id == 0;
  }

  /// Listener that automatically triggers fetchUserInfo() if the state becomes null.
  void _autoFetchOnNull(UserAccount newState) {
    if (newState.userAccountInfoModel.id == 0 &&
        !newState.isLoading &&
        !newState.hasError) {
      fetchUserInfo();
    }
  }

  /// Fetches the user account info from the API.
  Future<void> fetchUserInfo() async {
    // Set state to loading
    state = UserAccount(
      userAccountInfoModel: state.userAccountInfoModel,
      isLoading: true,
      hasError: false,
    );
    try {
      // Call the separated API to get the user info.
      UserAccountInfoModel userInfo = await UserAccountInfoApi.getUserAccountInfo();

      // If the API returns an id of 0 (default/null value), mark error.
      if (userInfo.id == 0) {
        state = UserAccount(
          userAccountInfoModel: userInfo,
          isLoading: false,
          hasError: true,
        );
      } else {
        state = UserAccount(
          userAccountInfoModel: userInfo,
          isLoading: false,
          hasError: false,
        );
      }
    } catch (error) {
      // Set an error state.
      state = UserAccount(
        userAccountInfoModel: UserAccountInfoModel(
          id: 0,
          password: "",
          lastLogin: null,
          isSuperuser: false,
          username: "Error",
          isStaff: false,
          isActive: false,
          dateJoined: DateTime.now(),
          email: "",
          firstName: "Error",
          lastName: "",
          phoneNumber: null,
          profilePicture: null,
          address: null,
          subscriptionStart: null,
          subscriptionEnd: null,
          isActiveSubscription: false,
          lastPaymentDate: null,
          registeredDate: DateTime.now(),
          role: ["Error"],
          plan: 0,
          groups: [],
          userPermissions: [],
        ),
        isLoading: false,
        hasError: true,
      );
    }
  }
}

final userAccountInfoProvider =
StateNotifierProvider<UserAccountNotifier, UserAccount>((ref) {
  return UserAccountNotifier();
});