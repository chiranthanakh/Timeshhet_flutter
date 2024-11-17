import 'dart:convert';

class LoginResponse {
  final int success;
  final String message;
  final List<UserData> data;

  LoginResponse({required this.success, required this.message, required this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List).map((item) => UserData.fromJson(item)).toList(),
    );
  }
}

class UserData {
  final String deptName;
  final String email;
  final String fullName;
  final bool isLoggedIn;
  final String mstUsersId;
  final String roleName;
  final String token;

  UserData({
    required this.deptName,
    required this.email,
    required this.fullName,
    required this.isLoggedIn,
    required this.mstUsersId,
    required this.roleName,
    required this.token,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      deptName: json['dept_name'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      isLoggedIn: json['isLoggedIn'] == 'true',
      mstUsersId: json['mst_users_id'] ?? '',
      roleName: json['role_name'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
