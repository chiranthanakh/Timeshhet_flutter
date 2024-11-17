import 'dart:convert';

import 'package:first/TimesheetData.dart';
import 'package:first/TimesheetService.dart';
import 'package:first/models/projectModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'SharedPrefHelper.dart';
import 'main.dart';
import 'models/TimesheetEntry.dart';

class MainActivityTimeSheet extends StatefulWidget {
  @override
  Mainscreen createState() => Mainscreen();
}

class Mainscreen extends State<MainActivityTimeSheet> {
  final SharedPrefHelper _sharedPrefHelper = SharedPrefHelper();
  final TimesheetService timesheetService = TimesheetService();
  List<TimesheetData> timesheets = [];
  List<Map<String, TextEditingController>> rows = []; // List to store controllers for each row's cells
  int _numberOfRows = 0;
  int week = 0; // Initial week
  String _displaymonth = "";
  String? _username;
  String _userid = "";
  String _roll = "";
  String _departmentId = "";


  late List<String> dates = [];
  late List<String> dates2 = [];

  List<Map<String, dynamic>> _rowsData = [];
  late String projectData = "";
  List<Map<String, dynamic>> projectslists = [];
  List<Project> _projects = [];


  @override
  void initState() {
    super.initState();
    _loadUsername();
    _fetchProjects();
    week = getFinancialWeek(DateTime.now());
    _displaymonth = getMonthNameAndYearFromWeek(week,2024);
  }


  @override
  Widget build(BuildContext context) {
    dates = getDatesForFinancialWeek(2024, week);
    dates2 = getDatesForFinancia(2024, week);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150), // Custom height for AppBar
        child: AppBar(
          backgroundColor: Colors.white, // Background color of the AppBar
          elevation: 5, // Add shadow
          flexibleSpace: Container(
            color: Colors.white, // Ensures flexibleSpace also has a white background
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Center Logo
                Image.asset(
                  'assets/renew_logo.png',
                  width: 200,
                  height: 60,
                ),
                // Employee Name Row
                Row(
                  children: [
                    // Centered Icon and Text
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 28),
                          const Icon(Icons.person, color: Color(0xFF1B5E20),),

                           Text(
                            _username! ,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Refresh button aligned to the end (right)
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.black),
                      onPressed: () {
                        // Add refresh logic here
                      },
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/card_shadow_actionbar.png'), // Replace with your Flutter asset
                  fit: BoxFit.cover,
                ),
              ),

              child: SizedBox(
                height: 250, // Set an appropriate height
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // User Icon
                    Center(
                      child: Image.asset(
                        'assets/user_icon.png', // Replace with your Flutter asset
                        width: 64,
                        height: 64,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children:  [
                        Expanded(
                          flex: 6,
                          child: Text(
                            "Name:",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          flex: 7,
                          child: Text(
                            _username!, // Replace with dynamic content
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            maxLines: 1, // Ensure the text stays on a single line
                            overflow: TextOverflow.ellipsis, // Truncate text with ellipsis if it overflows
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    // Role Row
                    Row(
                      children:  [
                        Expanded(
                          flex: 6,
                          child: Text(
                            "Role:",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          flex: 7,
                          child: Text(
                            _roll, // Replace with dynamic content
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Plant Name Row (Hidden)

                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Home'),
              onTap: () {
                // Add navigation logic here
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                // Add navigation logic here
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Change Password'),
              onTap: () {
                // Add navigation logic here
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                print("onTapclicked");
                _sharedPrefHelper.setLoginStatusname("");
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                color: Colors.white,  // Set the background color to white
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 130),
                        child: Text(
                          _displaymonth,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add,
                        size: 30,
                          color: Color(0xFF1B5E20),),
                      onPressed: _addNewRow,
                    ),
                  ],
                ),
              ),
            ),

            // Week Navigation
            Container(
              color: Colors.white,
              height: 50,
              margin: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left),
                    iconSize: 40.0,
                    onPressed: _decrementWeek,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Week: $week",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right),
                    iconSize: 40.0,
                    onPressed: _incrementWeek,
                  ),
                ],
              ),
            ),
            // Horizontal ScrollView for Days Header and Table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Days Header
                  Row(
                    children: [
                      _buildHeaderCell('Projecs'),
                      for (String date in dates) _buildHeaderCell(date),
                      _buildHeaderCell('Total'),
                      _buildHeaderCell("."),
                    ],
                  ),
                  for (int i = 0; i < _numberOfRows; i++) _buildEditableRow(i),
                ],
              ),
            ),
            // Total Hours and Save/Submit Buttons
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Total Hours: ${_calculateTotalHours().toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Save & Draft"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: generateRequestBody,
                  child: const Text("Submit"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableRow(int index) {
    final row = _rowsData[index];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown for project selection
        Container(
          width: 110,
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text('Select Project'),
            value: row["project"], // Use the row's specific project value
            items: _projects
                .map((project) => DropdownMenuItem(
              value: project.id,
              child: Text(
                project.projectName,
                overflow: TextOverflow.ellipsis,
              ),
            ))
                .toList(),
            onChanged: (String? value) {
              setState(() {
                row["project"] = value; // Update the specific row's project
              });
            },
          ),
        ),
        // TextFields for daily values
        // TextFields for daily values
        for (int dayIndex = 0; dayIndex < 5; dayIndex++)
          Container(
            width: 112,
            height: 40,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8),
                hintText: row["days"][dayIndex],
              ),
              textAlign: TextAlign.center,
              onChanged: (value) {
                setState(() {
                  // Parse and validate the entered value
                  double enteredValue = double.tryParse(value) ?? 0;
                  if (enteredValue > 9) {
                    // Show toast if the value exceeds 9
                    _showMessage("Total hrs cannot exceeds 9 hrs");
                    row["days"][dayIndex] = ""; // Reset invalid input
                  } else {
                    // Update the valid input
                    row["days"][dayIndex] = value;
                    row["date"][dayIndex] = dates2[dayIndex];
                  }
                });
                _updateTotal(index); // Update total after each change
              },
            ),
          ),
        // TextField for total
        Container(
          width: 110,
          height: 40,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(8),
              hintText: "Total",
            ),
            textAlign: TextAlign.center,
            controller: TextEditingController(text: row["total"]),
            readOnly: true,
          ),
        ),
        // Delete button
        Container(
          width: 60,
          height: 40,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(left: 10, top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                _rowsData.removeAt(index); // Remove the row data
                _numberOfRows = _rowsData.length;
              });
            },
          ),
        ),
      ],
    );
  }

  Future<void> fetchData() async {
    _rowsData.clear();
    _numberOfRows = 0;
    bool? isLoggedIn = await _sharedPrefHelper.getLoginStatus();
    final data = await timesheetService.fetchTimesheets(_userid);
    setState(() {
      timesheets = data;
      print(timesheets);
      prepareRowsData("33");
    });
  }

  Future<void> _fetchProjects() async {
    try {
      final projects = await timesheetService.getAllProjects(_departmentId); // Replace '1' with department ID
      setState(() {
        _projects = projects;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _addNewRow() {
    setState(() {
      _numberOfRows++;
      _rowsData.add({
        "project": null, // New project field
        "days": ["","","","",""], // 5 empty daily values
        "total": "", // Total field
        "date": ["","","","",""], // Include the first date encountered
        "mst_timesheets_id": ["","","","",""],
        "user_id": "",
        "status": "2"
      });
    });
  }

  void _incrementWeek() {
    setState(() {
      week++; // Increment week
      dates = getDatesForFinancialWeek(2024, week); // Update dates
      _numberOfRows = 0;
      _rowsData.clear();
      prepareRowsData(week.toString());
    });
  }
  void _decrementWeek() {
    setState(() {
      week--; // Increment week
      dates = getDatesForFinancialWeek(2024, week); // Update dates
      _displaymonth = getMonthNameAndYearFromWeek(week,2024);
      _numberOfRows = 0;
      _rowsData.clear();
      prepareRowsData(week.toString());
    });
  }

  void prepareRowsData( String weekNo) {
    List<Map<String, dynamic>> timesheetsAsMap = timesheets.map((data) => data.toMap()).toList();
    List<Map<String, dynamic>> filteredData = timesheetsAsMap
        .where((item) => item['week_no'] == weekNo)
        .toList();
    Map<String, List<Map<String, dynamic>>> groupedData = {};
    for (var item in filteredData) {
      String projectId = item['mst_projects_id'];
      if (!groupedData.containsKey(projectId)) {groupedData[projectId] = [];}
      groupedData[projectId]!.add(item);
    }
    String? userId;
    print("data timeshhet : ${groupedData}");
    groupedData.forEach((projectId, projectEntries) {
      List<String> days = List.filled(5, "");
      List<String> firstDate = List.filled(5, "");
      List<String> mstTimesheetsId = List.filled(5, "");// Initialize 5 empty daily values
      double totalHours = 0;

      for (var entry in projectEntries) {
        // Map the date to a weekday index (0 = Monday, 4 = Friday)
        DateTime date = DateTime.parse(entry['date']);
        int dayIndex = date.weekday - 1;
        if (dayIndex >= 0 && dayIndex < 5) {
          final parsedHrs = double.tryParse(entry['hrs'] ?? '0') ?? 0.0;
          print("Check project: Parsed hrs = $totalHours, Raw hrs = ${entry['hrs']}, Row project = ${projectEntries}");
          days[dayIndex] = parsedHrs.toString(); // Store as a string
          totalHours += parsedHrs; // Accumulate total hours
          firstDate[dayIndex] = entry['date'];
          mstTimesheetsId[dayIndex] = entry['mst_timesheets_id'];
        }
        userId = entry['user_id'];
      }


      setState(() {
        _numberOfRows++;
        _rowsData.add({
          "project": projectId,
          "days": days,
          "total": totalHours.toStringAsFixed(2),
          "date": firstDate, // Include the first date encountered
          "mst_timesheets_id": mstTimesheetsId,
          "user_id": userId,
          "status": "2"
        });
      });
    });
     print("Processed Rows Data: ${_rowsData}");
  }

  @override
  void dispose() {
    for (var row in rows) {
      row.values.forEach((controller) => controller.dispose());
    }
    super.dispose();
  }

  double _calculateTotalHours() {
    double totalHours = 0;
    for (var row in _rowsData) {
      for (var day in row["days"]) {
        if (day.isNotEmpty) {
          totalHours += double.tryParse(day) ?? 0; // Safely parse the value
        }
      }
    }
    return totalHours;
  }

  void _checkTotalHours(Map<String, dynamic> row) {
    // Parse hours from the "days" field
    final totalHours = row["days"]
        .where((value) => value.isNotEmpty) // Ignore empty values
        .map((value) => double.tryParse(value) ?? 0) // Parse to double, default to 0
        .reduce((a, b) => a + b); // Sum all values

    // Check if total exceeds 9 hours
    if (totalHours > 9) {
      _showMessage("Total for the day cannot exceed 9 hrs");
    }
  }

  Widget _buildHeaderCell(String title) {
    return Container(
      width: 110,
      height: 40,
      alignment: Alignment.center,
      margin: EdgeInsets.only(right: 2),
      decoration: BoxDecoration(
        color: Color(0xFF1B5E20),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }

  void _updateTotal(int rowIndex) {

    final row = _rowsData[rowIndex];
    print("row data : ${row["days"]}");
    final total = row["days"]
        .where((day) => day.isNotEmpty) // Filter out empty strings
        .map((day) => double.tryParse(day) ?? 0.0) // Safely parse each value
        .reduce((a, b) => a + b); // Sum up the values
    setState(() {
      row["total"] = total.toStringAsFixed(2); // Format total to 2 decimal places
    });
  }

  List<String> getDatesForFinancialWeek(int financialYear, int weekNumber) {
    List<String> dates = [];
    DateTime startOfFinancialYear = DateTime(financialYear, 4, 1);
    if (DateTime.now().isBefore(startOfFinancialYear)) {
      startOfFinancialYear = DateTime(financialYear - 1, 4, 1);
    }
    DateTime weekStartDate = startOfFinancialYear.add(Duration(days: (weekNumber - 1) * 7));
    DateFormat dateFormat = DateFormat('EEEE dd-MM-yy');
    for (int i = 0; i < 5; i++) {
      dates.add(dateFormat.format(weekStartDate.add(Duration(days: i))));
    }
    return dates;
  }

  List<String> getDatesForFinancia(int financialYear, int weekNumber) {
    List<String> dates = [];
    DateTime startOfFinancialYear = DateTime(financialYear, 4, 1);
    if (DateTime.now().isBefore(startOfFinancialYear)) {
      startOfFinancialYear = DateTime(financialYear - 1, 4, 1);
    }
    DateTime weekStartDate = startOfFinancialYear.add(Duration(days: (weekNumber - 1) * 7));
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    for (int i = 0; i < 5; i++) {
      dates.add(dateFormat.format(weekStartDate.add(Duration(days: i))));
    }
    return dates;
  }

  int getFinancialWeek(DateTime currentDate) {
    final int fiscalStartMonth = 4; // April
    final int fiscalStartDay = 1;
    DateTime fiscalYearStart =
    DateTime(currentDate.year, fiscalStartMonth, fiscalStartDay);
    if (currentDate.isBefore(fiscalYearStart)) {
    fiscalYearStart = DateTime(currentDate.year - 1, fiscalStartMonth, fiscalStartDay);}
    int daysSinceFiscalYearStart = currentDate.difference(fiscalYearStart).inDays;
    week = daysSinceFiscalYearStart;
    return (daysSinceFiscalYearStart ~/ 7) + 1;
    }

  String getMonthNameAndYearFromWeek(int financialWeek, int startYear ) {
    DateTime financialYearStart = DateTime(startYear, 4, 1);
    DateTime weekStartDate = financialYearStart.add(Duration(days: (financialWeek - 1) * 7));
    return DateFormat('MMMM yyyy').format(weekStartDate);
  }

  void generateRequestBody() {
    List<TimesheetEntry> timesheetEntries = [];
    for (var row in _rowsData) {
      String projectId = row['project'];
      List<String> days = row['days'];
      String totalHours = row['total'];
      List<String> firstDate = row['date'];
      List<String> mstTimesheetsId = row['mst_timesheets_id'] ?? ""; // Assuming empty string for missing IDs
      String userId = _userid;
      String status = row['status'] ?? "2"; // Defaulting to "2" if status is missing
      String weekNo = week.toString(); // Set this dynamically as per your requirements
      String year = "2024"; // Set this dynamically as per your requirements

      // Loop through days (5 days in total)
      for (int i = 0; i < days.length; i++) {

        if (days[i].isNotEmpty) {

          TimesheetEntry entry = TimesheetEntry(
            date: firstDate[i], // Assuming `firstDate` maps to `date`
            hrs: days[i], // Assuming `totalHours` maps to `hrs`
            mstProjectsId: projectId, // Assuming `projectId` maps to `mst_projects_id`
            mstTimesheetsId: mstTimesheetsId[i],
            status: status,
            updatedUserId: userId, // Default value
            userId: userId,
            weekNo: week.toString(), // Example: replace with actual week logic if needed
            year: year, // Example: replace with actual year logic if needed
          );
          timesheetEntries.add(entry);
        }
      }
    }

    // Final request body
    Map<String, dynamic> requestBody = {
      'data': timesheetEntries.map((entry) => entry.toJson()).toList(),
    };

    print('Timesheet request: $requestBody');
    try {
      final response =  timesheetService.addTimesheet(requestBody);
      fetchData();
      print('Timesheet API Response: $requestBody');
    } catch (e) {
      print('Error submitting timesheet: $e');
    }
    print(requestBody);

    }

  Future<void> _loadUsername() async {
    String? username = await _sharedPrefHelper.getusername();
    String? userid = await _sharedPrefHelper.getuserid();
    String? userrole = await _sharedPrefHelper.getuserrole();
    String? departmentid = await _sharedPrefHelper.getdepartementid();
    print("loginstatus ${userid}");
    setState(() {
      _username = username;
      _userid = userid!;//userid!;
      _roll = userrole!;
      _departmentId = departmentid!;
    });
    fetchData();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

}

