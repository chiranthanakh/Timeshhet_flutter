import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MainScreen.dart';
import 'SharedPrefHelper.dart';
import 'models/LoginModule.dart';

class EmployeeActivity extends StatefulWidget {

  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();

}


class _EmployeeListPageState extends State<EmployeeActivity> {

  List<DelegateEmployee> _delegates = [];
  final SharedPrefHelper _sharedPrefHelper = SharedPrefHelper();
  @override
  void initState() {
    super.initState();
    _fetchDelegates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Background color
        elevation: 4, // Adds shadow to the AppBar
        iconTheme: const IconThemeData(color: Colors.green), // Sets drawer icon color
        centerTitle: true, // Center the title (logo in this case)
        title: Image.asset(
          'assets/renew_logo.png', // Path to your logo
          width: 150, // Adjust logo size as needed
          height: 50,
        ),
      ),
      body: _delegates.isEmpty
          ? Center(child: CircularProgressIndicator()) // Loading state
          : SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Your text view before the list
              Text(
                'Select User', // Text to show before the list
                style: TextStyle(
                  fontSize: 20, // Adjust font size as needed
                  fontWeight: FontWeight.bold, // Make it bold
                  color: Colors.black, // Customize the color
                ),
              ),
              SizedBox(height: 20), // Space between the text and list
              // Now the list of delegates
              ..._delegates.isNotEmpty
                  ? _delegates.map((delegate) => Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onTap: () async {
                    // Save user preferences after tapping
                    await _sharedPrefHelper.saveUserPreferences(
                      isLoggedIn: true, // Set the login status based on your logic
                      userName: delegate.fullName,
                      userID: delegate.userid,
                      roleName: delegate.userrole,
                      roleID: delegate.roleid,
                      departmentID: delegate.departmentid,
                      departmentName: delegate.departmentid, // You can modify based on your logic
                      emailID: delegate.email,
                      token: 'your_token_here', // Replace with actual token if needed
                      changePasswordFlag: '1', // Example flag, modify as needed
                      employeeNamesList: ['Employee 1', 'Employee 2'], // Example list
                      employeeIdsList: ['1', '2'], // Example list
                    );

                    // Navigate to the next screen and pass delegate details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainActivityTimeSheet(
                          delegate: delegate, // Pass the delegate object
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      delegate.fullName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Email: ${delegate.email}",
                    ),
                    leading: Icon(Icons.person, color: Colors.green),
                  ),
                ),
              ))
                  : [Text("No delegated employees found.")],
            ],
          ),
        ),
      ),
    );
  }




  Future<List<DelegateEmployee>> getDelegatedEmployees() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? delegatedEmployeesJson = prefs.getString('delegatedEmployees');
    if (delegatedEmployeesJson != null) {
      List<dynamic> jsonList = jsonDecode(delegatedEmployeesJson);
      return jsonList.map((json) => DelegateEmployee.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> _fetchDelegates() async {
    List<DelegateEmployee> delegates = await getDelegatedEmployees();
    setState(() {
      _delegates = delegates;
    });
  }
}

class DelegateEmployee {
  final String fullName;
  final String email;
  final String roleid;
  final String userid;
  final String userrole;
  final String departmentid;

  DelegateEmployee({required this.fullName, required this.email, required this.roleid, required this.userid, required this.userrole, required this.departmentid});

  factory DelegateEmployee.fromJson(Map<String, dynamic> json) {
    return DelegateEmployee(
      fullName: json['full_name'],
      email: json['email'],
      roleid: json['role_name'],
      userid: json['mst_users_id'],
      userrole: json['email'],
      departmentid: json['mst_departments_id'],
    );
  }
}
