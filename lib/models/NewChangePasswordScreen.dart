import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For HTTP requests
import 'dart:convert';

import '../SharedPrefHelper.dart'; // For JSON decoding

class NewChangePasswordScreen extends StatefulWidget {
  @override
  _NewChangePasswordScreenState createState() => _NewChangePasswordScreenState();
}

class _NewChangePasswordScreenState extends State<NewChangePasswordScreen> {
  // Controllers for the text fields
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final SharedPrefHelper _sharedPrefHelper = SharedPrefHelper();

  bool _isLoading = false;
  String _roll = "";
  String _userId = "";

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  // Method to handle password change
  Future<void> _changePassword() async {
    // Validate fields first
    if (_newPasswordController.text != _confirmPasswordController.text) {
      // Show error message if passwords don't match
      _showMessage('New Password and Confirm Password do not match');
      return;
    }

    if (_oldPasswordController.text.isEmpty || _newPasswordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      _showMessage('Please fill in all fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://your-api-endpoint.com/change-password'),
        body: json.encode({
          'old_password': _oldPasswordController.text,
          'new_password': _newPasswordController.text,
        }),
        headers: {
          'Content-Type': 'application/json',
          // Add other necessary headers like Authorization if required
        },
      );

      // Check if the response was successful
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          _showMessage('Password changed successfully');
          Navigator.pop(context); // Navigate back to the previous screen
        } else {
          _showMessage(responseData['message'] ?? 'An error occurred');
        }
      } else {
        _showMessage('Failed to change password');
      }
    } catch (e) {
      _showMessage('An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to show messages
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
          'assets/renew_logo.png',
          width: 150,
          height: 50,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Heading Text
              Text(
                "Change Password",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Form container
              Container(
                padding: EdgeInsets.all(20),
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
                    // Email ID Text
                    Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    SizedBox(height: 5),
                    // Email ID Field (non-editable)
                    TextField(
                      controller: TextEditingController(text: ''),
                      decoration: InputDecoration(
                        hintText: _roll,
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      enabled: false,
                    ),
                    SizedBox(height: 20),

                    // Old Password Text
                    Text(
                      "Old Password",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    SizedBox(height: 5),
                    // Old Password Field
                    TextField(
                      controller: _oldPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Enter old password",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "New Password",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    SizedBox(height: 5),
                    // New Password Field
                    TextField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Enter new password",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Confirm Password",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    SizedBox(height: 5),
                    // Confirm Password Field
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Enter confirm password",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _changePassword, // Disable while loading
                      child: _isLoading
                          ? CircularProgressIndicator() // Show loading spinner
                          : Text(
                        "Submit",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4CAF50),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadUsername() async {
    String? username = await _sharedPrefHelper.getusername();
    String? userid = await _sharedPrefHelper.getuserid();
    String? userrole = await _sharedPrefHelper.getuserrole();
    String? departmentid = await _sharedPrefHelper.getdepartementid();
    String? rollid = await _sharedPrefHelper.getrollid();
    String? email = await _sharedPrefHelper.getemail();

    print("loginstatus ${userid}");
    setState(() {
      _roll = email!;
      _userId = userid!;
    });
  }

  Future<void> changePassword() async {
   // final url = 'https://devtashseet.proteam.co.in/backend/api/web/Users/changepassword';
    final url = 'https://renewtimesheet.proteam.co.in/backend/api/web/Users/changepassword';

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showMessage('New Password and Confirm Password do not match');
      return;
    }

    if (_oldPasswordController.text.isEmpty || _newPasswordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      _showMessage('Please fill in all fields');
      return;
    }

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'email': _roll,
      'newpassword': _newPasswordController.text,
      'old': _oldPasswordController.text,
      'user_id': _userId,
    });

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['success'] == 1) {
          setState(() {
            _showMessage(responseData['message']);
          });
        } else {
          setState(() {
            _showMessage('Failed to change password.');
          });
        }
      } else {
        setState(() {
          _showMessage('Error: ${response.statusCode}');
        });
      }
    } catch (e) {
      setState(() {
        _showMessage('Error: ${e}');
      });
    }
  }
}

