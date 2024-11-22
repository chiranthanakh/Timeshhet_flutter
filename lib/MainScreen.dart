import 'dart:convert';
import 'dart:core';
import 'dart:core';

import 'package:first/TimesheetData.dart';
import 'package:first/TimesheetService.dart';
import 'package:first/models/projectModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'EmployeeActivity.dart';
import 'SharedPrefHelper.dart';
import 'main.dart';
import 'models/TimesheetEntry.dart';

class MainActivityTimeSheet extends StatefulWidget {

  final DelegateEmployee delegate;

  // Constructor to receive delegate data
  const MainActivityTimeSheet({Key? key, required this.delegate}) : super(key: key);


  @override
  Mainscreen createState() => Mainscreen();
}

class Mainscreen extends State<MainActivityTimeSheet> {
  final SharedPrefHelper _sharedPrefHelper = SharedPrefHelper();
  final TimesheetService timesheetService = TimesheetService();
  List<TimesheetData> timesheets = [];
  bool _isLoading = false;
  List<Map<String, TextEditingController>> rows = []; // List to store controllers for each row's cells
  int _numberOfRows = 0;
  int week = 0; // Initial week
  int currentWeek = 0;
  String _displaymonth = "";
  String? _username;
  String _userid = "";
  String _roll = "";
  String _departmentId = "";
  String _rollid = "";
  String? _statusMessage = "";
  String? submitstatus = "0";


  late List<String> dates = [];
  late List<String> dates2 = [];

  List<Map<String, dynamic>> _rowsData = [];
  late String projectData = "";
  List<Map<String, dynamic>> projectslists = [];
  List<Project> _projects = [];
  List<String> weekNumbers = [];

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _fetchProjects();
    _fetchStatus();

    currentWeek = getFinancialWeek(DateTime.now());
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
          color: Colors.lightGreenAccent, // Ensures flexibleSpace also has a white background
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Renew Logo
                  const SizedBox(width: 25),
                  Image.asset(
                    'assets/renew_logo.png',
                    width: 200,
                    height: 60,
                  ),
                  // Filter Icon
                  IconButton(
                    icon: const Icon(Icons.filter_alt, color: Color(0xFF1B5E20)),
                    onPressed: () {
                      showFilterPopup(context); // Add your filter popup logic
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Employee Name Row
              Row(
                children: [
                  // Centered Icon and Text
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 28),
                        const Icon(Icons.person, color: Color(0xFF1B5E20)),
                        Text(
                          _username!,
                          style: const TextStyle(
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
                    icon: const Icon(Icons.refresh, color: Colors.white),
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
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Name Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Center the row horizontally
                          children: [
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
                          mainAxisAlignment: MainAxisAlignment.center, // Center the row horizontally
                          children: [
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
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                                overflow: TextOverflow.ellipsis, // Truncate with ellipsis if too long
                                softWrap: false, // Prevent wrapping to the next line
                              ),
                            ),
                          ],
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
                color: Colors.white60,  // Set the background color to white
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
                    Visibility(
                      visible: _isDateValid(),
                      replacement: const SizedBox(), // Replaces the IconButton when hidden
                      child: IconButton(
                        icon: const Icon(
                          Icons.add,
                          size: 30,
                          color: Color(0xFF1B5E20),
                        ),
                        onPressed: _addNewRow,
                      ),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Week: $week",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                          const SizedBox(width: 10), // Space between the two Text widgets
                          Text(
                            _statusMessage!, // Replace with dynamic or static content
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Customize color as needed
                            ),
                          ),
                        ],
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
            Stack(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (!_isLoading) {
                              setState(() {
                                submitstatus = "0";
                                _isLoading = true; // Show the loader
                              });
                              generateRequestBody().then((_) {
                                setState(() {
                                  _isLoading = false; // Hide the loader after processing
                                });
                              }).catchError((error) {
                                setState(() {
                                  _isLoading = false; // Ensure loader is hidden on error
                                });
                                // Handle error here
                              });
                            }
                          },
                          child: _isLoading && submitstatus == "0"
                              ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                              : const Text("Save & Draft"),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (!_isLoading) {
                              setState(() {
                                submitstatus = _rollid == "4" ? "2" : "1";
                                _isLoading = true; // Show the loader
                              });
                              generateRequestBody().then((_) {
                                setState(() {
                                  _isLoading = false; // Hide the loader after processing
                                });
                              }).catchError((error) {
                                setState(() {
                                  _isLoading = false; // Ensure loader is hidden on error
                                });
                                // Handle error here
                              });
                            }
                          },
                          child: _isLoading && (submitstatus == "1" || submitstatus == "2")
                              ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                              : const Text("Submit"),
                        ),
                      ],
                    ),


                  ],
                ),
                if (_isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black54,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _calculateRowTotal(List<String> days) {
    return days
        .map((day) => double.tryParse(day) ?? 0.0) // Parse each day's value safely
        .fold(0.0, (sum, value) => sum + value); // Sum up the hours
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
            onChanged: (row["project"] == null || row["project"]!.isEmpty)
                ? (String? value) {
              if (_rowsData.any((r) => r["project"] == value)) {
                // Show popup if the project is already selected
                _showMessage( "Project already selected.");
              } else {
                setState(() {
                  row["project"] = value; // Update the specific row's project
                });
              }
            }
                : null, // Disable dropdown if project is not null or empty
            style: TextStyle(
              color: (row["project"] == null || row["project"]!.isEmpty)
                  ? Colors.black
                  : Colors.white, // Optional: Change text color to indicate disabled state
            ),
          ),
        ),

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
                    _showMessage("Total hrs cannot exceed 9 hrs");
                    row["days"][dayIndex] = ""; // Reset invalid input
                  } else {
                    // Update the valid input
                    row["days"][dayIndex] = value;
                    row["date"][dayIndex] = dates2[dayIndex];
                  }
                  // Recalculate total hours
                  row["total"] = _calculateRowTotal(row["days"]).toStringAsFixed(2);
                });
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
            controller: TextEditingController(text: _calculateRowTotal(row["days"]).toStringAsFixed(2)),
            readOnly: true, // Total is read-only
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

  //code for filters
  void showFilterPopup(BuildContext context) {
    List<String> financialYears = [];
    List<String> financialMonths = [];
    List<String> financialWeeks = [];
    String? selectedYear;
    String? selectedMonth;
    String? selectedWeek;
    var extractedYear;

    // Generate financial years (April to March)
    DateTime now = DateTime.now();
    int startYear = now.month > 3 ? now.year : now.year - 1;
    int endYear = startYear + 1;

    financialYears.add("${startYear}-${endYear}");
    financialYears.add("${2023}-${2024}");
    financialYears.add("${2022}-${2023}");
    financialYears.add("${2021}-${2022}");
    financialYears.add("${2020}-${2021}");
    // Generate financial months (April to March)
    financialMonths = [
      "April $startYear",
      "May $startYear",
      "June $startYear",
      "July $startYear",
      "August $startYear",
      "September $startYear",
      "October $startYear",
      "November $startYear",
      "December $startYear",
      "January $endYear",
      "February $endYear",
      "March $endYear"
    ];

    // Generate weeks for a selected month
    void generateWeeksForMonth(String month) {
      financialWeeks.clear();

      // Map the month string to a month number
      Map<String, int> monthMap = {
        'April': 4,
        'May': 5,
        'June': 6,
        'July': 7,
        'August': 8,
        'September': 9,
        'October': 10,
        'November': 11,
        'December': 12,
        'January': 1,
        'February': 2,
        'March': 3,
      };

      int year = month.contains(startYear.toString()) ? startYear : endYear;
      int monthIndex = monthMap[month.split(' ')[0]]!;
      DateTime firstDay = DateTime(year, monthIndex, 1);
      DateTime lastDay = DateTime(year, monthIndex + 1, 0);

      int weekCount = 1;
      DateTime weekStart = firstDay;

      while (weekStart.isBefore(lastDay)) {
        DateTime weekEnd = weekStart.add(Duration(days: 6));
        if (weekEnd.isAfter(lastDay)) weekEnd = lastDay;

        financialWeeks.add(
          "Week $weekCount: ${weekStart.day}/${weekStart.month} - ${weekEnd.day}/${weekEnd.month}",
        );
        weekStart = weekEnd.add(Duration(days: 1));
        weekCount++;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: 250,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Select Year Label
                    const Text(
                      'Select Year',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: selectedYear,
                      hint: const Text('Select Year'),
                      items: financialYears
                          .map((year) => DropdownMenuItem(
                        value: year,
                        child: Text(year),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedYear = value; // Set the full financial year string
                          extractedYear = int.parse(value!.split('-')[1]); // Extract 2024
                          print("Selected Year: $extractedYear");
                        });
                      },
                      underline: const SizedBox(),
                    ),
                    const SizedBox(height: 10),

                    // Select Month Label
                    const Text(
                      'Select Month',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: selectedMonth,
                      hint: const Text('Select Month'),
                      items: financialMonths
                          .map((month) => DropdownMenuItem(
                        value: month,
                        child: Text(month),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMonth = value; // Set the full month string

                          // Extract numeric month from "August 2023"
                          List<String> monthParts = value!.split(' ');
                          String monthName = monthParts[0]; // Get "August"
                          int numericMonth = {
                            "January": 1,
                            "February": 2,
                            "March": 3,
                            "April": 4,
                            "May": 5,
                            "June": 6,
                            "July": 7,
                            "August": 8,
                            "September": 9,
                            "October": 10,
                            "November": 11,
                            "December": 12,
                          }[monthName]!;
                          print("Selected Month: $numericMonth");

                          // Update weeks based on the selected month
                          calculateFinancialWeek(extractedYear, numericMonth);
                          selectedWeek = null; // Reset week selection
                        });
                      },
                      underline: const SizedBox(),
                    ),
                    const SizedBox(height: 10),

                    // Select Week Number Label
                    const Text(
                      'Select Week Number',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: selectedWeek,
                      hint: const Text('Select Week Number'),
                      items: weekNumbers
                          .map((week) => DropdownMenuItem(
                        value: week,
                        child: Text(week),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedWeek = value;
                        });
                      },
                      underline: const SizedBox(),
                    ),
                    const SizedBox(height: 20),

                    // Search Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setSelection(int.parse(selectedWeek!));
                          Navigator.pop(context); // Close popup and handle search
                          print(
                              "Selected: Year=$selectedYear, Month=$selectedMonth, Week=$selectedWeek");
                        },
                        child: const Text('Search'),
                      ),
                    ),
                  ],
                );
              },
            ),

          ),
        );
      },
    );
  }


  Future<void> fetchData() async {
    _rowsData.clear();
    _numberOfRows = 0;
    final data = await timesheetService.fetchTimesheets(_userid);
    setState(() {
      timesheets = data;
      print(timesheets);
      prepareRowsData(week.toString());
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

  Future<void> _fetchStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await timesheetService.fetchStatusByWeek(_userid, week.toString(), 2024);
      print("printgstgatgu ${result["status"]}");
      if (result["status"] == "0") {
        setState(() {
          _statusMessage ="Draft";
        });
      } else  if (result["status"] == 1) {
        setState(() {
          _statusMessage ="Submitted";
        });
      }else  if (result["status"] == "2") {
        setState(() {
          _statusMessage ="Approved";
        });
      }else  {
        setState(() {
          _statusMessage = "";
        });
      }
    } catch (error) {
      setState(() {
        _statusMessage = "Error: $error";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
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
      _fetchStatus();
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
      _fetchStatus();
    });
  }
  void setSelection(int selectedweek) {
    setState(() {
      week =selectedweek; // Increment week
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
          "status": "0"
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
  List<String> getDatesForFinancialWeek(int financialYear, int weekNumber) {
    print("financial year ${financialYear} ${weekNumber}"  );
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

  void calculateFinancialWeek(int selectedYear, int selectedMonth) {
    print("Financial year: $selectedYear, Month: $selectedMonth");

    // Determine the financial year's starting date
    DateTime financialYearStart = DateTime(selectedYear, 4, 1);
    if (selectedMonth < 4) {
      financialYearStart = DateTime(selectedYear - 1, 4, 1); // Adjust for months before April
    }

    // Get the start and end dates of the selected month
    DateTime monthStart = DateTime(selectedYear, selectedMonth, 1);
    DateTime monthEnd = DateTime(selectedYear, selectedMonth + 1, 0);

    // Clear and update the weekNumbers list
    List<String> newWeekNumbers = [];

    for (int day = 1; day <= monthEnd.day; day++) {
      DateTime currentDate = DateTime(selectedYear, selectedMonth, day);
      int daysDifference = currentDate.difference(financialYearStart).inDays;
      int weekNumber = (daysDifference ~/ 7) + 1; // Week numbers start at 1

      if (!newWeekNumbers.contains(weekNumber.toString())) {
        newWeekNumbers.add(weekNumber.toString());
      }
    }

    // Update the weekNumbers list in state
    setState(() {
      weekNumbers = newWeekNumbers;
    });

    print("Week numbers: $weekNumbers");
  }

   generateRequestBody() async {
    setState(() {
      _isLoading = true; // Show loader
    });

    try {
      List<TimesheetEntry> timesheetEntries = [];
      for (var row in _rowsData) {
        String projectId = row['project'];
        List<String> days = row['days'];
        String totalHours = row['total'];
        List<String> firstDate = row['date'];
        List<String> mstTimesheetsId = row['mst_timesheets_id'] ?? ""; // Assuming empty string for missing IDs
        String userId = _userid;
        String? status = submitstatus;//\\\status1.toString() ?? "2"; // Defaulting to "2" if status is missing
        String weekNo = week.toString(); // Set this dynamically as per your requirements
        String year = "2024"; // Set this dynamically as per your requirements

        // Loop through days (5 days in total)
        for (int i = 0; i < days.length; i++) {
          if (days[i].isNotEmpty) {
            TimesheetEntry entry = TimesheetEntry(
              date: firstDate[i],
              hrs: days[i],
              mstProjectsId: projectId,
              mstTimesheetsId: mstTimesheetsId[i],
              status: status,
              updatedUserId: userId,
              userId: userId,
              weekNo: weekNo,
              year: year,
            );
            timesheetEntries.add(entry);
          }
        }
      }

      Map<String, dynamic> requestBody = {
        'data': timesheetEntries.map((entry) => entry.toJson()).toList(),
      };

      print('Timesheet request: $requestBody');
      final response = await timesheetService.addTimesheet(requestBody); // Make API call
      refresh();
      print('Timesheet API Response: $response');
    } catch (e) {
      print('Error submitting timesheet: $e');
    } finally {
      setState(() {
        _isLoading = false; // Hide loader
      });
    }
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
    fetchData();
  }
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
  void refresh() {
    week = getFinancialWeek(DateTime.now());
    prepareRowsData(week.toString());
    fetchData();
  }

  _isDateValid() {
    if(currentWeek < week){
      return false;
    } else {
      return true;
    }
  }

}

