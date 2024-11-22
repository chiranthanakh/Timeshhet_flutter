import 'dart:convert';

class DelegateEmployee {
  final String mstUsersId;
  final String mstDepartmentsId;
  final String fullName;
  final String mstRolesId;
  final String email;
  final bool isLoggedIn;
  final String roleName;
  final String deptName;

  // Constructor
  DelegateEmployee({
    required this.mstUsersId,
    required this.mstDepartmentsId,
    required this.fullName,
    required this.mstRolesId,
    required this.email,
    required this.isLoggedIn,
    required this.roleName,
    required this.deptName,
  });

  // Factory method to create an instance from JSON
  factory DelegateEmployee.fromJson(Map<String, dynamic> json) {
    return DelegateEmployee(
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

  // Convert an instance to JSON
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
