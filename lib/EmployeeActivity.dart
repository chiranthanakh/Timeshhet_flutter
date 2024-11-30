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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // The text 'Select User' above the grid
              Text(
                'Select User', // Text to show before the grid
                style: TextStyle(
                  fontSize: 20, // Adjust font size as needed
                  fontWeight: FontWeight.bold, // Make it bold
                  color: Colors.black, // Customize the color
                ),
              ),
              SizedBox(height: 20), // Space between the text and grid

              // GridView to display the delegates
              _delegates.isNotEmpty
                  ? GridView.builder(
                shrinkWrap: true, // Makes the gridView take only the required height
                physics: NeverScrollableScrollPhysics(), // Disable scroll in GridView
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 16.0, // Horizontal space between grid items
                  mainAxisSpacing: 16.0, // Vertical space between grid items
                  childAspectRatio: 1.0, // Aspect ratio for each card
                ),
                itemCount: _delegates.length,
                itemBuilder: (context, index) {
                  var delegate = _delegates[index];
                  return Card(
                    elevation: 4,
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
                          departmentName: delegate.departmentName, // You can modify based on your logic
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
                      child: GridTile(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: 150.0, // Set fixed width for the card
                            height: 120.0, // Set fixed height for the card
                            decoration: BoxDecoration(
                             // borderRadius: BorderRadius.circular(8), // Optional: add rounded corners
                              color: Colors.white, // Optional: set background color
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3), // Offset shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 50.0, // Fixed width for the icon
                                    height: 50.0, // Fixed height for the icon
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.green,
                                      size: 60.0, // Icon size within the fixed box
                                    ),
                                  ),
                                  SizedBox(height: 8), // Add spacing between icon and text
                                  Center(  // Center the text horizontally
                                    child: Text(
                                      "${delegate.fullName}",
                                      textAlign: TextAlign.center,  // This ensures text is centered if needed
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
                  : Text("No delegated employees found."),
            ],
          ),
        ),
      ),
    );
  }


  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Colors.white, // Background color
  //       elevation: 4, // Adds shadow to the AppBar
  //       iconTheme: const IconThemeData(color: Colors.green), // Sets drawer icon color
  //       centerTitle: true, // Center the title (logo in this case)
  //       title: Image.asset(
  //         'assets/renew_logo.png', // Path to your logo
  //         width: 150, // Adjust logo size as needed
  //         height: 50,
  //       ),
  //     ),
  //     body: _delegates.isEmpty
  //         ? Center(child: CircularProgressIndicator()) // Loading state
  //         : SingleChildScrollView(
  //       child: Container(
  //         padding: EdgeInsets.all(16),
  //         child: Column(
  //           children: [
  //             // Your text view before the list
  //             Text(
  //               'Select User', // Text to show before the list
  //               style: TextStyle(
  //                 fontSize: 20, // Adjust font size as needed
  //                 fontWeight: FontWeight.bold, // Make it bold
  //                 color: Colors.black, // Customize the color
  //               ),
  //             ),
  //             SizedBox(height: 20), // Space between the text and list
  //             // Now the list of delegates
  //             ..._delegates.isNotEmpty
  //                 ? _delegates.map((delegate) => Card(
  //               elevation: 4,
  //               margin: EdgeInsets.symmetric(vertical: 8),
  //               child: GestureDetector(
  //                 onTap: () async {
  //                   // Save user preferences after tapping
  //                   await _sharedPrefHelper.saveUserPreferences(
  //                     isLoggedIn: true, // Set the login status based on your logic
  //                     userName: delegate.fullName,
  //                     userID: delegate.userid,
  //                     roleName: delegate.userrole,
  //                     roleID: delegate.roleid,
  //                     departmentID: delegate.departmentid,
  //                     departmentName: delegate.departmentName, // You can modify based on your logic
  //                     emailID: delegate.email,
  //                     token: 'your_token_here', // Replace with actual token if needed
  //                     changePasswordFlag: '1', // Example flag, modify as needed
  //                     employeeNamesList: ['Employee 1', 'Employee 2'], // Example list
  //                     employeeIdsList: ['1', '2'], // Example list
  //                   );
  //
  //                   // Navigate to the next screen and pass delegate details
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => MainActivityTimeSheet(
  //                         delegate: delegate, // Pass the delegate object
  //                       ),
  //                     ),
  //                   );
  //                 },
  //                 // child: ListTile(
  //                 //   title: Text(
  //                 //     delegate.fullName,
  //                 //     style: TextStyle(fontWeight: FontWeight.bold),
  //                 //   ),
  //                 //   subtitle: Text(
  //                 //     "Email: ${delegate.email}",
  //                 //   ),
  //                 //   leading: Icon(Icons.person, color: Colors.green),
  //                 // ),
  //                 child: GridTile(
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Container(
  //                       width: 150.0,  // Set fixed width for the card
  //                       height: 120.0, // Set fixed height for the card
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(8),  // Optional: add rounded corners
  //                         color: Colors.white,  // Optional: set background color
  //                         boxShadow: [
  //                           BoxShadow(
  //                             color: Colors.grey.withOpacity(0.2),
  //                             spreadRadius: 1,
  //                             blurRadius: 5,
  //                             offset: Offset(0, 3), // Offset shadow
  //                           ),
  //                         ],
  //                       ),
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: [
  //                             SizedBox(
  //                               width: 50.0,  // Fixed width for the icon
  //                               height: 50.0, // Fixed height for the icon
  //                               child: Icon(
  //                                 Icons.person,
  //                                 color: Colors.green,
  //                                 size: 40.0, // Icon size within the fixed box
  //                               ),
  //                             ),
  //                             SizedBox(height: 8),  // Add spacing between icon and text
  //                             Text("Name: ${delegate.fullName}"),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //
  //                   ),
  //                 ),
  //
  //
  //               ),
  //             ))
  //                 : [Text("No delegated employees found.")],
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }






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
  final String departmentName;


  DelegateEmployee({required this.fullName, required this.email, required this.roleid, required this.userid, required this.userrole, required this.departmentid,required this.departmentName});

  factory DelegateEmployee.fromJson(Map<String, dynamic> json) {
    return DelegateEmployee(
      fullName: json['full_name'],
      email: json['email'],
      roleid: json['role_name'],
      userid: json['mst_users_id'],
      userrole: json['role_name'],
      departmentid: json['mst_departments_id'],
      departmentName: json['dept_name'],
    );
  }
}
