import 'dart:convert';
import 'dart:math';

import 'package:first/LoginResponse.dart';
import 'package:first/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'EmployeeActivity.dart';
import 'SharedPrefHelper.dart';
import 'Welcome.dart';
import 'ApiServices.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'My App',
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _LoginActivityTimeSheetState(),
      routes: {
        '/login': (context) => _LoginActivityTimeSheetState(),
        '/employee': (context) => EmployeeActivity(),
        '/main': (context) => MainActivityTimeSheet(delegate: DelegateEmployee(fullName: "", email: "",userid:"",userrole:"",departmentid:"", roleid: '', departmentName:"")),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SharedPrefHelper _sharedPrefHelper = SharedPrefHelper();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
   // await _sharedPrefHelper.setLoginStatus(true);
   //  SharedPreferences prefs = await SharedPreferences.getInstance();
   //  // String isLoggedIn = prefs.getString('isLoggedIn');
   //  // final SharedPreferences prefs = await SharedPreferences.getInstance();
   //  String? login =  prefs.getString('username');
   // print("login Status ${login}");
   //  if (login != "") {
   //    Navigator.pushReplacementNamed(context, '/main');
   //  } else {
   //    Navigator.pushReplacementNamed(context, '/login');
   //  }
  }

  @override
  Widget build(BuildContext context) {
    _checkLoginStatus();
    return Scaffold(

    );
  }
}

class _LoginActivityTimeSheetState extends StatefulWidget {
  @override
  LoginActivityTimeSheet createState() => LoginActivityTimeSheet();
}

class LoginActivityTimeSheet extends State<_LoginActivityTimeSheetState> {
  late LoginResponse loginResponse;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
   final ApiService _apiService = ApiService();
 // final TimesheetService _apiService = TimesheetService();

  final SharedPrefHelper _sharedPrefHelper = SharedPrefHelper();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
   checklogin();
  }


  Future<void> _login(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showMessage('Please enter both username and password.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (response != null && response.success == 1) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', "true");
        await prefs.reload();
        setState(() {
          loginResponse = response;
        });
        if(loginResponse.data[0].delegatedEmp.length == 1) {
          var values = loginResponse.data[0].delegatedEmp[0];
          await _sharedPrefHelper.saveUserPreferences(
            isLoggedIn: values.isLoggedIn,
            userName: values.fullName,
            userID: values.mstUsersId,
            roleName: values.roleName,
            roleID: values.mstRolesId,
            departmentID: values.mstDepartmentsId,
            departmentName: values.deptName,
            emailID: values.email,
            token: "",
            changePasswordFlag: values.mstUsersId,
          );
        } else if (loginResponse.data[0].delegatedEmp.length == 0){
          await _sharedPrefHelper.saveUserPreferences(
            isLoggedIn: loginResponse.data[0].isLoggedIn,
            userName: loginResponse.data[0].fullName,
            userID: loginResponse.data[0].mstUsersId,
            roleName: loginResponse.data[0].roleName,
            roleID: loginResponse.data[0].mstRolesId, // Fixed duplicated roleName
            departmentID: loginResponse.data[0].mstDepartmentsId, // Updated correct property
            departmentName: loginResponse.data[0].deptName,
            emailID: loginResponse.data[0].email,
            token: loginResponse.data[0].token,
            changePasswordFlag: loginResponse.data[0].mstUsersId,
          );
        }
        print("check employye role ${loginResponse.data[0].roleName}");
        // Navigate based on delegated employees
        if (loginResponse.data[0].delegatedEmp.length <= 1 ) {
          Navigator.pushReplacementNamed(context, '/main');
        } else {
          Navigator.pushReplacementNamed(context, '/employee');
          await prefs.setString('username', "true2");
          await prefs.reload();
        }

        _showMessage('Login Successful');
      } else {
        _showMessage('Invalid Email or Password');
      }
    } catch (e) {
      // Log and display specific error
      print('Login error: $e');
      _showMessage('Something Went wrong');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height, // Make the gradient cover full screen
          width: double.infinity,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0x000000),
                  Color(0x000000),
                  Color(0x000000),// Light green
                  Color(0x95C3E88D), // Darker green
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 50), // Adjust height for spacing
                Image.asset(
                  'assets/renew_logo.png',
                  width: 250,
                  height: 60,
                ),
                SizedBox(height: 20),
                Text(
                  'Time Sheet Management System',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF319038),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Image.asset(
                  'assets/login_page_timesheet.png',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //   colors: [
                      //     Color(0x000000),
                      //     Color(0x000000),//
                      //     Color(0x000000),
                      //     Color(0x000000),
                      //     Color(0x000000),// Light green
                      //     Color(0x95DFF5C2), // Darker green
                      //   ],
                      //   begin: Alignment.topCenter,
                      //   end: Alignment.bottomCenter,
                      // ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: 'UserName',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.person, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFF319038)),
                            ),
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 10),
                      TextFormField(
                        obscureText: !_isPasswordVisible,  // Toggle between true and false
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.lock, color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              // Toggle the password visibility when the eye icon is tapped
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Color(0xFF319038)),
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _isLoading ? null : () => _login(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF319038),
                            fixedSize: Size(150, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Version : 1.0 ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF707070),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checklogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? login =  prefs.getString('username');
    if (login != "" && login != null && login == "true") {
      Navigator.pushReplacementNamed(context, '/main');
    } else if (login != "" && login != null && login == "true2") {
      Navigator.pushReplacementNamed(context, '/employee');
    }
  }

}

