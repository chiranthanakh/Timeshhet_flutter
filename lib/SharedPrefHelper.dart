import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPrefHelper {
  static const String _isLoggedInKey = 'isLoggedIn';

  Future<void> setLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool success = await prefs.setBool(_isLoggedInKey, true);
    print('Set login status: $success');
  }

  Future<void> setLoginStatusname(String isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     await prefs.setString("username", isLoggedIn );
    print('Set login status: ');
  }

  Future<bool?> getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? status = prefs.getBool(_isLoggedInKey);
    print('Set login retrieved: $status');
    return status;
  }

  Future<String?> getusername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString("user_name");
    print('get username: $username');
    return username;
  }

  Future<String?> getuserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usernid = prefs.getString("user_id");
    print('get userid: $usernid');
    return usernid;
  }

  Future<String?> getuserrole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usernrole = prefs.getString("role_name");
    print('get userid: $usernrole');
    return usernrole;
  }
  Future<String?> getrollid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usernrole = prefs.getString("role_id");
    print('get role_id: $usernrole');
    return usernrole;
  }

  Future<String?> getdepartementid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usernrole = prefs.getString("department_id");
    print('get userid: $usernrole');
    return usernrole;
  }


  Future<void> saveUserPreferences({
    required bool isLoggedIn,
    required String userName,
    required String userID,
    required String roleName,
    required String roleID,
    required String departmentID,
    required String departmentName,
    required String emailID,
    required String token,
    required String changePasswordFlag,
    List<String>? employeeNamesList,
    List<String>? employeeIdsList,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', isLoggedIn);
    await prefs.setString('user_name', userName);
    await prefs.setString('user_id', userID);
    await prefs.setString('role_name', roleName);
    await prefs.setString('role_id', roleID);
    await prefs.setString('department_id', departmentID);
    await prefs.setString('department_name', departmentName);
    await prefs.setString('email_id', emailID);
    await prefs.setString('token', token);
    await prefs.setString('changePasswordFlag', changePasswordFlag);

    if (changePasswordFlag == "1") {
      try {
        String employeeNamesJson = jsonEncode(employeeNamesList);
        String employeeIdsJson = jsonEncode(employeeIdsList);

        await prefs.setString('employeeNamesList', employeeNamesJson);
        await prefs.setString('employeeIdsList', employeeIdsJson);
      } catch (e) {
        print("Failed to add list in Shared Preferences: $e");
      }
    }
  }
}