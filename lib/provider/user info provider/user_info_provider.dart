import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/user_account_controller.dart';
import '../../models/user info model/user_info_model.dart';

class UserAccountInfoNotifier extends StateNotifier<UserAccountInfoModel> {
  UserAccountInfoNotifier()
      : super(UserAccountInfoModel(
    id: 0,
    password: "",
    lastLogin: null,
    isSuperuser: false,
    username: "loading",
    isStaff: false,
    isActive: false,
    dateJoined: DateTime.now(),
    email: "",
    firstName:  "Loading Name",
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
  )) {
    fetchUserInfo();
  }

  void fetchUserInfo() async {
    try {
      state = UserAccountInfoModel(
        id: 0,
        password: "",
        lastLogin: null,
        isSuperuser: false,
        username: "loading",
        isStaff: false,
        isActive: false,
        dateJoined: DateTime.now(),
        email: "",
        firstName:  "Loading Name",
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
      );
      UserAccountInfoModel userInfo = await UserAccountInfoApi.getUserAccountInfo();
      state = userInfo;

    } catch (error) {
      // Handle error state if needed (for example, you could log error or set a specific error state)
      UserAccountInfoModel userAccountInfoModel = UserAccountInfoModel(
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
      );
      state = userAccountInfoModel;
    }
  }
}

final userAccountInfoProvider =
StateNotifierProvider<UserAccountInfoNotifier, UserAccountInfoModel>((ref) {
  return UserAccountInfoNotifier();
});
