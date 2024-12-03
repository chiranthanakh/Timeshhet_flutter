import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'SharedPrefHelper.dart';


class Reportsscreen extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<Reportsscreen> {
  String selectedStatus = 'Draft';
  List<String> statusOptions = ['Draft', 'Submitted'];
  String? _username = "";
  String? _userid = "";
  bool _isLoading = true;
  List<Map<String, dynamic>> _timesheetData = [];
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

        backgroundColor: Color(0xFFFFFF), // Hamburger Icon Color
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Title Text
            Text(
              'Reports',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4CAF50), // Hamburger Icon Color
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),

            // Username and Spinner (DropdownButton)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: TextField(
                    readOnly: true, // Make the text field read-only
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: _username,
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                      hintStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: DropdownButton<String>(
                    value: selectedStatus,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.transparent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatus = newValue!;
                        // Map "Submitted" to 1 and other values to 2
                        if (selectedStatus == "Submitted") {
                          fetchReports(_userid!, "2");
                        } else {
                          fetchReports(_userid!, "0"); // set value to "2" for other selections
                        }
                      });
                      print("selected Status ${selectedStatus}");
                      fetchReports(_userid!, selectedStatus);
                    },
                    items: statusOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),

                ),
              ],
            ),

            SizedBox(height: 20),

            Table(
              border: TableBorder.all(
                color: Colors.black, // Border color
                width: 1,
                borderRadius: BorderRadius.circular(1),
              ),
              children: [
                TableRow(
                  children: [
                    _buildTableCell('S.No.', 50, 25),
                    _buildTableCell('Project', 120, 25),
                    _buildTableCell('Week No.', 80, 25),
                    _buildTableCell('Year', 80, 25),
                  ],
                ),
                ..._timesheetData.map((item) {
                  return TableRow(
                    children: [
                      _buildTableCell2(item["sno"], 50, 25),
                      _buildTableCell2(item["project"], 120, 25),
                      _buildTableCell2(item["weekNo"], 80, 25),
                      _buildTableCell2(item["year"], 80, 25),
                    ],
                  );
                }).toList(),
              ],
            ),


            // Back Button at the bottom
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous screen
                },
                child: Text('Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4CAF50), // Hamburger Icon Color
                  minimumSize: Size(double.infinity, 50),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, double width, double height) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell2(String text, double width, double height) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }


  Future<void> fetchReports(String userId, String status) async {

    //final url = Uri.parse("https://devtashseet.proteam.co.in/backend/api/web/Timesheet/get_all_timesheet_by_status");
    final url = Uri.parse("https://renewtimesheet.proteam.co.in/backend/api/web/Timesheet/get_all_timesheet_by_status");
    final body = jsonEncode({
      "status": status,
      "user_id": userId,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == 1) {
          List<dynamic> timesheets = responseData['data'];
          List<Map<String, dynamic>> fetchedData = timesheets.map((item) {
            return {
              "sno": item["count"].toString(),
              "project": item["mst_projects_id"],
              "weekNo": item["week_no"],
              "year": item["year"],
            };
          }).toList();

          setState(() {
            _timesheetData = fetchedData;
            _isLoading = false;
          });
        } else {
          print("Error: ${responseData['message']}");
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error occurred: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUsername() async {
    String? username = await _sharedPrefHelper.getusername();
    String? userid = await _sharedPrefHelper.getuserid();
    setState(() {
      _username = username;
      _userid = userid;
      fetchReports(_userid!, "0");
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}