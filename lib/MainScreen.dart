import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:ffi';

import 'package:first/ReportsScreen.dart';
import 'package:first/TimesheetData.dart';
import 'package:first/TimesheetService.dart';
import 'package:first/UserprofileScreen.dart';
import 'package:first/models/NewChangePasswordScreen.dart';
import 'package:first/models/projectModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'EmployeeActivity.dart';
import 'SharedPrefHelper.dart';
import 'main.dart';
import 'models/TimesheetEntry.dart';

class MainActivityTimeSheet extends StatefulWidget {
  final DelegateEmployee delegate;
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
  int week = 0;
  int selectedYear = 2024;
  int currentWeek = 0;
  String _displaymonth = "";
  String? _username;
  String _userid = "";
  String _roll = "";
  String _departmentId = "";
  String _rollid = "";
  String _email = "";
  String? _statusMessage = "";
  String? submitstatus = "0";
  String approveBuuten = "";
  String submitButton = "";
  bool isEmployee = false;
  List<TextEditingController> _controllers = List.generate(5, (index) => TextEditingController());



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

    currentWeek = getFinancialWeek(DateTime.now());
    week = getFinancialWeek(DateTime.now());
    _displaymonth = getMonthNameAndYearFromWeek(week,selectedYear);
    _loadUsername();
    _fetchProjects();
    _fetchStatus(currentWeek);
  }


  @override
  Widget build(BuildContext context) {
    dates = getDatesForFinancialWeek(selectedYear, week);
    dates2 = getDatesForFinancia(selectedYear, week);
    print("checkStatus321 ${dates}");
    return Scaffold(
      backgroundColor: Colors.white,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt, color: Colors.green), // Filter icon
            onPressed: () {
              // Add your filter logic here
              print("Filter icon tapped");
              showFilterPopup(context); // Call your filter popup or logic
            },
          ),
        ],
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
                  height: 350, // Set an appropriate height
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, // Align Column content to the left
                    children: [
                      // User Icon (Remove Center widget to align it to the left)
                      Image.asset(
                        'assets/user_icon.png', // Replace with your Flutter asset
                        width: 54,
                        height: 54,
                      ),
                      const SizedBox(height: 5),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center, // Align children of Column to the left
                        children: [
                          // Name Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center, // Ensure the row aligns from the start
                            children: [
                              Text(
                                "Name:",
                                textAlign: TextAlign.end, // Align "Name:" text to the right
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _username!, // Replace with dynamic content
                                textAlign: TextAlign.start, // Align the username to the left
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                                maxLines: 1, // Ensure the text stays on a single line
                                overflow: TextOverflow.ellipsis, // Truncate text with ellipsis if it overflows
                              ),
                            ],
                          ),
                          //const SizedBox(height: 5),
                          // Role Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align the row from the start
                            children: [
                              // "Role:" text - align to the right
                              Text(
                                "Email:",
                                textAlign: TextAlign.end, // Align "Role:" text to the right
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              // Role text - Align to the left
                              Expanded(
                                child: Text(
                                  _email, // Replace with dynamic content
                                  textAlign: TextAlign.start, // Align the role text to the left
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                  overflow: TextOverflow.ellipsis, // Truncate with ellipsis if too long
                                  softWrap: false, // Prevent wrapping to the next line
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 3),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align the row from the start
                            children: [
                              Text(
                                "Role:",
                                textAlign: TextAlign.end, // Align "Role:" text to the right
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _roll, // Replace with dynamic content
                                textAlign: TextAlign.start, // Align the role text to the left
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                                overflow: TextOverflow.ellipsis, // Truncate with ellipsis if too long
                                softWrap: false, // Prevent wrapping to the next line
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),


            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Home'),
              onTap: () {
              print("Roll check : ${_roll}");
                if(_roll == "Employee") {
                  // Add navigation logic here
                  Navigator.pop(context);
                } else{
                  Navigator.pushReplacementNamed(context, '/employee');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfile(), // Navigate to ChangePasswordScreen
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Reports'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Reportsscreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Change Password'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewChangePasswordScreen(), // Navigate to ChangePasswordScreen
                  ),
                );
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
                color: Colors.white60, // Background color for the outer container
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Add padding around the content
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Shrink to fit content
                      children: <Widget>[
                        const Icon(
                          Icons.person, // Icon to display
                          size: 15, // Icon size
                          color: Color(0xFF1B5E20), // Icon color
                        ),
                        const SizedBox(width: 6), // Space between icon and text
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.lightGreen, // Background color for text
                            borderRadius: BorderRadius.circular(10), // Rounded corners for text background
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), // Padding around the text
                          child: Text(
                            _username!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ),
              ),
            ),

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
                      replacement: const SizedBox(),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 26.0), // Set right margin here
                        child: GestureDetector(
                          onTap: _addNewRow,
                          child: Image.asset(
                            'assets/add_plus.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
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

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Add padding
                            decoration: BoxDecoration(
                              color: _getStatusBackgroundColor(),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _statusMessage!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Days Header

                  Row(
                    children: [
                      _buildHeaderCell('Projects'),
                      for (String date in dates) _buildHeaderCell(date),
                      _buildHeaderCell('Total'),
                      _buildHeaderCell("."),
                    ],
                  ),
                  for (int i = 0; i < _numberOfRows; i++) _buildEditableRow(i),
                ],
              ),
            ),
            const SizedBox(height: 40),
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
            const SizedBox(height: 20),
            Stack(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Show the confirmation dialog
                            _showSaveDraftConfirmationDialog();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                          ),
                          child: _isLoading && submitstatus == "0"
                              ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text("Save as Draft"),
                        ),

                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            _showConfirmationDialog("Are you sure you want to submit?");
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                          ),
                          child: _isLoading && (submitstatus == "1" || submitstatus == "2")
                              ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                              :  Text(approveBuuten),
                        ),
                      ],
                    ),
                  ],
                ),
                if (_isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.white,
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
        Container(
          width: 110,
          height: 40,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            isDense: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8.0),
              hintText: 'Select Project',
              hintStyle: TextStyle(
                fontSize: 12.0,
                color: Colors.black,
              ),
            ),
            value: row["project"],
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
                _showMessage("Project already selected.");
              } else {
                setState(() {
                  row["project"] = value;
                });
              }
            }
                : null,
            style: TextStyle(
              color: (row["project"] == null || row["project"]!.isEmpty)
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ),

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
                  num total = 0;
                  for (var row in _rowsData) {;
                    List<String> days = row['days'];

                      total += double.tryParse(days[dayIndex]) ?? 0;
                      print("------------123-${total}");
                  }

                  double enteredValue = double.tryParse(value) ?? 0;
                  if(total+enteredValue > 9) {
                    _showMessage("Total hrs per day cannot exceed 9 hrs");
                    row["days"][dayIndex] = "0";
                    enteredValue = 0;
                  } else if (enteredValue > 9) {
                    _showMessage("Total hrs cannot exceed 9 hrs");
                    row["days"][dayIndex] = "0";
                    enteredValue = 0;
                  } else {
                    row["days"][dayIndex] = value;
                    row["date"][dayIndex] = dates2[dayIndex];
                  }
                  // Recalculate total hours
                  row["total"] = _calculateRowTotal(row["days"]).toStringAsFixed(2);
                });
              },
            ),
          ),
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
        Container(
          width: 60,
          height: 40,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(left: 10, top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              var rowData = _rowsData[index];
              String projectId = "" ;
              if(rowData["project"] != null){
                projectId = rowData["project"] ;
              }
              _showDeleteConfirmationDialog(projectId,  index);
            },
          ),
        ),
      ],
    );
  }

  void showFilterPopup(BuildContext context) {
    List<String> financialYears = [];
    List<String> financialMonths = [];
    List<String> financialWeeks = [];
    String? selectedYear;
    int? yearselect;
    String? selectedMonth;
    String? selectedWeek;

    var extractedYear;
    DateTime now = DateTime.now();
    int startYear = now.month > 3 ? now.year : now.year - 1;
    int endYear = startYear + 1;

    financialYears.add("${startYear}-${endYear}");
    financialYears.add("${2023}-${2024}");
    financialYears.add("${2022}-${2023}");
    financialYears.add("${2021}-${2022}");
    financialYears.add("${2020}-${2021}");

    void calculateFinancialWeek(int selectedYear, int selectedMonth) {
      print("Financial year: $selectedYear, Month: $selectedMonth");

      // Start of the financial year (April 1st)
      DateTime financialYearStart = DateTime(selectedYear, 4, 1);
      if (selectedMonth < 4) {
        financialYearStart = DateTime(selectedYear - 1, 4, 1); // Adjust for months before April
      }

      DateTime monthStart = DateTime(selectedYear, selectedMonth, 1);
      DateTime monthEnd = DateTime(selectedYear, selectedMonth + 1, 0);
      List<String> newWeekNumbers = [];
      for (int day = 1; day <= monthEnd.day; day++) {
        DateTime currentDate = DateTime(selectedYear, selectedMonth, day);
        int daysDifference = currentDate.difference(financialYearStart).inDays;
        int weekNumber = (daysDifference ~/ 7) + 1;
        if (!newWeekNumbers.contains(weekNumber.toString())) {
          newWeekNumbers.add(weekNumber.toString());
        }
      }
      setState(() {
        weekNumbers = newWeekNumbers;
      });

      print("Week numbers: $weekNumbers");
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
                          selectedYear = value;
                          yearselect =int.parse(value!.split('-')[0]); // Set the full financial year string
                          extractedYear = int.parse(value!.split('-')[1]); // Extract 2024
                          extractedYear = int.parse(value!.split('-')[1]);
                          startYear = int.parse(value.split('-')[0]);
                          endYear = startYear + 1;
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
                         // financialMonths = getFinancialMonths(startYear, endYear);
                          print("Selected Year: $extractedYear");
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
                          selectedMonth = value;

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

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setSelection(yearselect!,int.parse(selectedWeek!));
                          Navigator.pop(context); // Close popup and handle search
                          print(
                              "Selected: Year=$selectedYear, Month=$selectedMonth, Week=$selectedWeek");
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green, // Text color
                          padding: EdgeInsets.symmetric(vertical: 15), // Button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                          ),
                        ),

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
    _fetchStatus(week);
  }
  Future<void> fetchclearData() async {
    _rowsData.clear();
    _numberOfRows = 0;
    final data = await timesheetService.fetchTimesheets(_userid);
    setState(() {
      timesheets = data;
      print(timesheets);
    });
  }

  Color _getStatusBackgroundColor() {
    switch (_statusMessage) {
      case "Draft":
        return Colors.yellow; // Background color for Draft
      case "Submitted":
        return Colors.green; // Background color for Submitted
      case "Approved":
        return Colors.lightGreen;
      default:
        return Colors.white; // Default ba
    }
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

  Future<void> _fetchStatus(int currentWeek) async {
    setState(() {
      _isLoading = true;
    });

    try {

      if(_userid == ""){
      _userid =   (await _sharedPrefHelper.getuserid())!;
      }
      print("Status checking by uri  ${currentWeek}");
      final result = await timesheetService.fetchStatusByWeek(_userid, currentWeek.toString(), selectedYear);
      print("ststus checking ${result["status"]}");
      if (result["status"] == "0") {
        setState(() {
          _statusMessage ="Draft";
        });
      } else  if (result["status"] == "1") {
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

  void _showSaveDraftConfirmationDialog() {
    var isEmpty = false;
    for (var row in _rowsData) {
      if (row['project'] == null) {
        isEmpty = true;
      }
    }
    if (isEmpty) {
      _showMessage("Please Select project to Proceed");
    } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Save & Draft'),
          content: Text('Are you sure you want to save as draft?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without performing the action
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                _saveDraftAction();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  }

  void _saveDraftAction() {
    if (!_isLoading) {
      setState(() {
        submitstatus = "0";
        _isLoading = true;
      });
      generateRequestBody().then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  void _showConfirmationDialog(String text) {
    var isEmpty = false;
    for (var row in _rowsData) {
      if (row['project'] == null) {
        isEmpty = true;
      }
    }
    if (isEmpty) {
      _showMessage("Please Select project to Proceed");
    } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Approve & Submit'),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                _submitAction();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    }
  }

  void _submitAction() {
    if (!_isLoading) {
      setState(() {
        //submitstatus = _rollid == "4" ? "2" : "1";
        if(isEmployee){
          submitstatus = "2";
        }else{
          submitstatus = "1";
        }
        _isLoading = true;
      });

      generateRequestBody().then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        // Handle error here
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
        "status": ""
      });
    });
  }
  void _incrementWeek() {
    fetchclearData();
    if (week == 53){
      week = 1;
      selectedYear++;
    }
    setState(() {
      week++; // Increment week
      dates = getDatesForFinancialWeek(selectedYear, week);
      _displaymonth = getMonthNameAndYearFromWeek(week,selectedYear);
      _numberOfRows = 0;
      _rowsData.clear();
      prepareRowsData(week.toString());
      _fetchStatus(week);
    });
  }
  void _decrementWeek() {
    fetchclearData();
    if (week == 1){
      week = 54;
      selectedYear--;
    }
    setState(() {
      week--;
      dates = getDatesForFinancialWeek(selectedYear, week);
      _displaymonth = getMonthNameAndYearFromWeek(week,selectedYear);
      _numberOfRows = 0;
      _rowsData.clear();
      prepareRowsData(week.toString());
      _fetchStatus(week);
    });
  }
  void setSelection(int year ,int selectedweek) {
    selectedYear = year;
    print("display months ${getDatesForFinancialWeek(year, week)}");
    setState(() {
      week =selectedweek;
      dates = getDatesForFinancialWeek(year, week);
      _displaymonth = getMonthNameAndYearFromWeek(week,year);
      _numberOfRows = 0;
      _rowsData.clear();
      prepareRowsData(week.toString());
    });
  }
  void delectRowInRimesheet(){
    timesheets.removeWhere((item) => item.mstProjectsId == 'specific_project_id');
  }
  void prepareRowsData( String weekNo) {
    List<Map<String, dynamic>> timesheetsAsMap = timesheets.map((data) => data.toMap()).toList();
    List<Map<String, dynamic>> filteredData = timesheetsAsMap
        .where((item) => item['week_no'] == weekNo)
        .toList();
    print("testtdsfjkk ${filteredData}");
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
      List<String> mstTimesheetsId = List.filled(5, "");
      double totalHours = 0;

      for (var entry in projectEntries) {
        DateTime date = DateTime.parse(entry['date']);
        int dayIndex = date.weekday - 1;
        if (dayIndex >= 0 && dayIndex < 5) {
          final parsedHrs = double.tryParse(entry['hrs'] ?? '0') ?? 0.0;
          print("Check project: Parsed hrs = $totalHours, Raw hrs = ${entry['hrs']}, Row project = ${projectEntries}");
          days[dayIndex] = parsedHrs.toString();
          totalHours += parsedHrs;
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
          "date": firstDate,
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
  // List<String> getDatesForFinancialWeek(int financialYear, int weekNumber) {
  //   print("financial year ${financialYear} ${weekNumber}"  );
  //   List<String> dates = [];
  //   DateTime startOfFinancialYear = DateTime(financialYear, 4, 1);
  //   if (DateTime.now().isBefore(startOfFinancialYear)) {
  //     startOfFinancialYear = DateTime(financialYear - 1, 4, 1);
  //   }
  //   DateTime weekStartDate = startOfFinancialYear.add(Duration(days: (weekNumber - 1) * 7));
  //   DateFormat dateFormat = DateFormat('EEEE dd-MM-yy');
  //   for (int i = 0; i < 5; i++) {
  //     dates.add(dateFormat.format(weekStartDate.add(Duration(days: i))));
  //   }
  //   return dates;
  // }


  List<String> getDatesForFinancialWeek(int financialYear, int weekNumber) {
    print("financial year ${financialYear} week number ${weekNumber}");
    List<String> dates = [];

    // Start of the financial year
    DateTime startOfFinancialYear = DateTime(financialYear, 4, 1);

    // If the current date is before the start of the financial year, adjust to previous year
    if (DateTime.now().isBefore(startOfFinancialYear)) {
      startOfFinancialYear = DateTime(financialYear - 1, 4, 1);
    }

    // Calculate the start date of the week
    DateTime weekStartDate = startOfFinancialYear.add(Duration(days: (weekNumber - 1) * 7));

    int weekday = weekStartDate.weekday;
    int daysToSubtract = (weekday == DateTime.monday)
        ? 0
        : (weekday == DateTime.sunday)
        ? 6
        : (weekday - DateTime.monday);

    weekStartDate = weekStartDate.subtract(Duration(days: daysToSubtract));

    // Format dates
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
    _fetchStatus((daysSinceFiscalYearStart ~/ 7) + 1);
    return (daysSinceFiscalYearStart ~/ 7) + 1;
    }
  String getMonthNameAndYearFromWeek(int financialWeek, int startYear ) {
    DateTime financialYearStart = DateTime(startYear, 4, 1);
    DateTime weekStartDate = financialYearStart.add(Duration(days: (financialWeek - 1) * 7));
    return DateFormat('MMMM yyyy').format(weekStartDate);
  }

  void calculateFinancialWeek(int selectedYear, int selectedMonth) {
    print("Financial year: $selectedYear, Month: $selectedMonth");
    DateTime financialYearStart = DateTime(selectedYear, 4, 1);
    if (selectedMonth < 4) {
      financialYearStart = DateTime(selectedYear - 1, 4, 1); // Adjust for months before April
    }
    DateTime monthStart = DateTime(selectedYear, selectedMonth, 1);
    DateTime monthEnd = DateTime(selectedYear, selectedMonth + 1, 0);

    List<String> newWeekNumbers = [];

    for (int day = 1; day <= monthEnd.day; day++) {
      DateTime currentDate = DateTime(selectedYear, selectedMonth, day);
      int daysDifference = currentDate.difference(financialYearStart).inDays;
      int weekNumber = (daysDifference ~/ 7) + 1;
      if (!newWeekNumbers.contains(weekNumber.toString())) {
        newWeekNumbers.add(weekNumber.toString());
      }
    }
    setState(() {
      weekNumbers = newWeekNumbers;
    });

    print("Week numbers: $weekNumbers");
  }


  // void calculateFinancialWeek(int selectedYear, int selectedMonth) {
  //   print("Financial year: $selectedYear, Month: $selectedMonth");
  //   DateTime financialYearStart = DateTime(selectedYear, 4, 1);
  //   if (selectedMonth < 4) {
  //     financialYearStart = DateTime(selectedYear - 1, 4, 1); // Adjust for months before April
  //   }
  //   DateTime monthStart = DateTime(selectedYear, selectedMonth, 1);
  //   DateTime monthEnd = DateTime(selectedYear, selectedMonth + 1, 0);
  //   List<String> newWeekNumbers = [];
  //
  //   for (int day = 1; day <= monthEnd.day; day++) {
  //     DateTime currentDate = DateTime(selectedYear, selectedMonth, day);
  //     int daysDifference = currentDate.difference(financialYearStart).inDays;
  //     int weekNumber = (daysDifference ~/ 7) + 1; // Week numbers start at 1
  //
  //     if (!newWeekNumbers.contains(weekNumber.toString())) {
  //       newWeekNumbers.add(weekNumber.toString());
  //     }
  //   }
  //   setState(() {
  //     weekNumbers = newWeekNumbers;
  //   });
  //
  //   print("Week numbers: $weekNumbers");
  // }

   generateRequestBody() async {
    setState(() {
      if ( _rowsData.length == 0) {
        _showMessage("Please Enter data to Save");
        _isLoading = true;
      } else {
        _isLoading = true;
      }
    });

    try {
      List<TimesheetEntry> timesheetEntries = [];
      for (var row in _rowsData) {
        String projectId = row['project'];
        List<String> days = row['days'];
        String totalHours = row['total'];
        List<String> firstDate = row['date'];
        List<String> mstTimesheetsId = row['mst_timesheets_id'] ?? "";
        String userId = _userid;
        String? status = submitstatus;
        String weekNo = week.toString();
        String year = "${selectedYear}";

        print("statuscheck looking ${submitstatus}");

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
      _fetchStatus(week);
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
    String? email = await _sharedPrefHelper.getemail();


    print("loginstatus ${userid}");
    setState(() {
      _username = username;
      _userid = userid!;//userid!;
      _roll = userrole!;
      _departmentId = departmentid!;
      _rollid = rollid!;
      _email = email!;
      if(_roll == "Employee"){
        isEmployee = true;
        approveBuuten = "Approve & Submit";
        submitButton =   "Save as Draft";
      } else {
        isEmployee = false;
        approveBuuten = "Submit";
        submitButton =  "Save as Draft";
      }
    });
    fetchData();
  }
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
  void refresh() {
   // week = getFinancialWeek(DateTime.now());
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

  void deleteRow(String projectId) {
     timesheetService.deleteTimesheet(projectId, _userid!, week.toString());
     _showMessage("Project Deleted Successfull");
     //refresh();
  }

  // Function to show the confirmation dialog for delete
  void _showDeleteConfirmationDialog(String projectId, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this row?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without deleting
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                var select = week;
                _deleteRowAction(projectId, _userid, index);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteRowAction(String projectId, String userId, int index) {
    setState(() {
      _rowsData.removeAt(index);
      deleteRow(projectId);
      _numberOfRows = _rowsData.length;
      print("delectedrow===> ${_numberOfRows}");

    });
  }
}

