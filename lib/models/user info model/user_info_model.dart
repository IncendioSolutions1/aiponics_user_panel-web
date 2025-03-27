import 'package:meta/meta.dart';

class UserAccountInfoModel {
  final int id;
  final String password;
  final DateTime? lastLogin;
  final bool isSuperuser;
  final String username;
  final bool isStaff;
  final bool isActive;
  final DateTime dateJoined;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? profilePicture;
  final String? address;
  final DateTime? subscriptionStart;
  final DateTime? subscriptionEnd;
  final bool isActiveSubscription;
  final DateTime? lastPaymentDate;
  final DateTime registeredDate;
  final List<String> role;
  final int plan;
  final List<dynamic> groups;
  final List<dynamic> userPermissions;

  UserAccountInfoModel({
    required this.id,
    required this.password,
    this.lastLogin,
    required this.isSuperuser,
    required this.username,
    required this.isStaff,
    required this.isActive,
    required this.dateJoined,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.profilePicture,
    this.address,
    this.subscriptionStart,
    this.subscriptionEnd,
    required this.isActiveSubscription,
    this.lastPaymentDate,
    required this.registeredDate,
    required this.role,
    required this.plan,
    required this.groups,
    required this.userPermissions,
  });

  factory UserAccountInfoModel.fromJson(Map<String, dynamic> json) {
    return UserAccountInfoModel(
      id: json['id'],
      password: json['password'],
      lastLogin: json['last_login'] != null ? DateTime.parse(json['last_login']) : null,
      isSuperuser: json['is_superuser'],
      username: json['username'],
      isStaff: json['is_staff'],
      isActive: json['is_active'],
      dateJoined: DateTime.parse(json['date_joined']),
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      profilePicture: json['profile_picture'],
      address: json['address'],
      subscriptionStart: json['subscription_start'] != null ? DateTime.parse(json['subscription_start']) : null,
      subscriptionEnd: json['subscription_end'] != null ? DateTime.parse(json['subscription_end']) : null,
      isActiveSubscription: json['is_active_subscription'],
      lastPaymentDate: json['last_payment_date'] != null ? DateTime.parse(json['last_payment_date']) : null,
      registeredDate: DateTime.parse(json['registered_date']),
      role: List<String>.from(json['role'] ?? []),
      plan: json['plan'],
      groups: json['groups'] ?? [],
      userPermissions: json['user_permissions'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
      'last_login': lastLogin?.toIso8601String(),
      'is_superuser': isSuperuser,
      'username': username,
      'is_staff': isStaff,
      'is_active': isActive,
      'date_joined': dateJoined.toIso8601String(),
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'profile_picture': profilePicture,
      'address': address,
      'subscription_start': subscriptionStart?.toIso8601String(),
      'subscription_end': subscriptionEnd?.toIso8601String(),
      'is_active_subscription': isActiveSubscription,
      'last_payment_date': lastPaymentDate?.toIso8601String(),
      'registered_date': registeredDate.toIso8601String(),
      'role': role,
      'plan': plan,
      'groups': groups,
      'user_permissions': userPermissions,
    };
  }
}
