class LoginResponse {
  final int success;
  final String message;
  final List<UserData> data;

  LoginResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'],
      message: json['message'],
      data: List<UserData>.from(json['data'].map((x) => UserData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}

class UserData {
  final String mstUsersId;
  final String mstDepartmentsId;
  final String fullName;
  final String mstRolesId;
  final String email;
  final String passwordChange;
  final bool isLoggedIn;
  final String roleName;
  final String deptName;
  final String token;
  final List<DelegateEmployee2> delegatedEmp;

  UserData({
    required this.mstUsersId,
    required this.mstDepartmentsId,
    required this.fullName,
    required this.mstRolesId,
    required this.email,
    required this.passwordChange,
    required this.isLoggedIn,
    required this.roleName,
    required this.deptName,
    required this.token,
    required this.delegatedEmp,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      mstUsersId: json['mst_users_id'],
      mstDepartmentsId: json['mst_departments_id'],
      fullName: json['full_name'],
      mstRolesId: json['mst_roles_id'],
      email: json['email'],
      passwordChange: json['password_change'],
      isLoggedIn: json['isLoggedIn'],
      roleName: json['role_name'],
      deptName: json['dept_name'],
      token: json['token'],
      delegatedEmp: List<DelegateEmployee2>.from(
        json['delegated_emp'].map((x) => DelegateEmployee2.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mst_users_id': mstUsersId,
      'mst_departments_id': mstDepartmentsId,
      'full_name': fullName,
      'mst_roles_id': mstRolesId,
      'email': email,
      'password_change': passwordChange,
      'isLoggedIn': isLoggedIn,
      'role_name': roleName,
      'dept_name': deptName,
      'token': token,
      'delegated_emp': delegatedEmp.map((x) => x!.toJson()).toList(),
    };
  }
}

class DelegateEmployee2 {
  final String mstUsersId;
  final String mstDepartmentsId;
  final String fullName;
  final String mstRolesId;
  final String email;
  final bool isLoggedIn;
  final String roleName;
  final String deptName;

  DelegateEmployee2({
    required this.mstUsersId,
    required this.mstDepartmentsId,
    required this.fullName,
    required this.mstRolesId,
    required this.email,
    required this.isLoggedIn,
    required this.roleName,
    required this.deptName,
  });

  factory DelegateEmployee2.fromJson(Map<String, dynamic> json) {
    return DelegateEmployee2(
      mstUsersId: json['mst_users_id'],
      mstDepartmentsId: json['mst_departments_id'],
      fullName: json['full_name'],
      mstRolesId: json['mst_roles_id'],
      email: json['email'],
      isLoggedIn: json['isLoggedIn'],
      roleName: json['role_name'],
      deptName: json['dept_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mst_users_id': mstUsersId,
      'mst_departments_id': mstDepartmentsId,
      'full_name': fullName,
      'mst_roles_id': mstRolesId,
      'email': email,
      'isLoggedIn': isLoggedIn,
      'role_name': roleName,
      'dept_name': deptName,
    };
  }
}

