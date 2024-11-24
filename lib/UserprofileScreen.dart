import 'package:flutter/material.dart';

import 'SharedPrefHelper.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileScreen createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfile> {

  String? _username;
  String _userid = "";
  String _roll = "";
  String _departmentId = "";
  String _rollid = "";
  final SharedPrefHelper _sharedPrefHelper = SharedPrefHelper();

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        iconTheme: IconThemeData(color: Colors.green),
        centerTitle: true,
        title: Image.asset(
          'assets/user_icon.png',
          width: 150,
          height: 50,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Refresh logic here
            },
            color: Colors.green,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Container(), // You can customize this with logo or user info
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                // Handle profile navigation
              },
            ),
            // Add more Drawer items as per your requirement
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // User Info Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    buildUserProfileRow("User Name:", _username!),
                    buildUserProfileRow("User ID:", _userid),
                    buildUserProfileRow("Email ID:", _roll),
                    buildUserProfileRow("Role Name:", _rollid),
                    buildUserProfileRow("Role ID:", _rollid),
                    buildUserProfileRow("Department:", _departmentId),
                    buildUserProfileRow("Department ID:", _departmentId),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Back button action
                  Navigator.pop(context);
                },
                child: Text("Back"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              value,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadUsername() async {
    String? username = await _sharedPrefHelper.getusername();
    String? userid = await _sharedPrefHelper.getuserid();
    String? userrole = await _sharedPrefHelper.getuserrole();
    String? departmentid = await _sharedPrefHelper.getdepartementid();
    String? rollid = await _sharedPrefHelper.getrollid();

    print("loginstatus ${userid}");
    setState(() {
      _username = username;
      _userid = userid!;//userid!;
      _roll = userrole!;
      _departmentId = departmentid!;
      _rollid = rollid!;
    });
  }
}
