import 'dart:convert';
import 'package:first/TimesheetData.dart';
import 'package:first/models/projectModel.dart';
import 'package:http/http.dart' as http;

import 'LoginResponse.dart';
import 'models/TimesheetResponce.dart';

class TimesheetService {


  // Function to fetch timesheet data and return a list of mst_projects_id
  Future<List<String>> fetchProjectIds(String userId) async {
    final String apiUrl = "https://devtashseet.proteam.co.in/backend/api/web/Timesheet/get_all";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"user_id": userId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData["success"] == 1) {
          List<dynamic> timesheetData = responseData["data"];
          // Parse mst_projects_id and return it as a list of strings
          return timesheetData
              .map((item) => item["mst_projects_id"] as String)
              .toList();
        } else {
          print("Error: ${responseData["message"]}");
          return [];
        }
      } else {
        print("Failed to load timesheets. Status Code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<Object?> login(String username, String password) async {
    final String baseUrl = 'https://devtashseet.proteam.co.in/backend/api/web/validate_login';
    final url = Uri.parse(baseUrl);
    print('Base URL: $url'); // Debug log
    try {
      final request = http.MultipartRequest('POST', url);
      request.fields['email'] = username;
      request.fields['password'] = password;

      // Optional: Remove hardcoded cookie or update dynamically
      request.headers['Cookie'] = 'ci_session=your_dynamic_session_token';
      print('Request fields: ${request.fields}');

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      print('Response status: ${responseBody.statusCode}');
      print('Response body: ${responseBody.body}');

      if (responseBody.statusCode == 200) {
        final jsonResponse = jsonDecode(responseBody.body);
        if (jsonResponse['success'] == 1) {
          return LoginResponse.fromJson(jsonResponse);
        } else {
          print("API Error: ${jsonResponse['message']}");
        }
      } else {
        print('HTTP Error: ${responseBody.statusCode}');
      }
    } catch (e, stackTrace) {
      return e;
      print('Error occurred during login: $e');
      print('Stack trace: $stackTrace');
    }
    return null;
  }



  Future<List<Project>> getAllProjects(String departmentId) async {
    const String apiUrl =
        'https://devtashseet.proteam.co.in/backend/api/web/Project/get_all_projects';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'mst_departments_id': departmentId});

    try {
      final response = await http.post(Uri.parse(apiUrl), headers: headers, body: body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == 1) {
          final List<dynamic> projectsJson = responseData['data'];
          return projectsJson.map((json) => Project.fromJson(json)).toList();
        } else {
          throw Exception('Failed to fetch projects: ${responseData['message']}');
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching projects: $e');
      rethrow;
    }
  }

  Future<List<TimesheetData>> fetchTimesheets(String userId) async {
    final String baseUrl = 'https://devtashseet.proteam.co.in/backend/api/web/Timesheet/get_all';
    final String sessionCookie = 'ci_session=43971f933da5f9a1cac203410f5db33f7250fe6a';
    final url = Uri.parse(baseUrl);
    List<TimesheetData> timesheetList = [];
    try {
      final request = http.MultipartRequest('POST', url);
      request.fields['user_id'] = userId;
      request.headers['Cookie'] = sessionCookie;
      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (responseBody.statusCode == 200) {
        final jsonResponse = jsonDecode(responseBody.body);
       print(jsonResponse);
        if (jsonResponse['success'] == 1) {

          final Map<String, dynamic> jsonResponse = jsonDecode(responseBody.body);
          final timesheetResponse = TimesheetResponse.fromJson(jsonResponse);
          print("all data ${timesheetResponse.data}");
          return timesheetResponse.data;
        } else {
          print('Failed to fetch timesheets: ${jsonResponse['message']}');
        }
      } else {
        print('Error: ${responseBody.statusCode}');
      }
    } catch (e) {
      print('Error in fetchTimesheets: $e');
    }

    return timesheetList;
  }

  Future<Map<String, dynamic>> fetchStatusByWeek(String userId, String weekNo, int year) async {
    const String url = "https://devtashseet.proteam.co.in/backend/api/web/Timesheet/get_status_by_week_no";

    // Request body
    final Map<String, String> requestBody = {
      "user_id": userId,
      "week_no": weekNo,
      "year": year.toString(),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(requestBody),
      );

      // Check the response status code
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data; // Returns the decoded JSON map
      } else {
        throw Exception("Failed to fetch data: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("Error occurred: $error");
    }
  }

  // Function to add timesheet data
  // Future<Map<String, dynamic>> addTimesheet(List<Map<String, dynamic>> timesheetData) async {
  //   const String apiUrl = 'https://devtashseet.proteam.co.in/backend/api/web/Times';
  //   final headers = {'Content-Type': 'application/json'};
  //   final body = jsonEncode({
  //     'data': timesheetData,
  //   });
  //
  //   try {
  //     final response = await http.post(Uri.parse(apiUrl), headers: headers, body: body);
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseData = json.decode(response.body);
  //       if (responseData['success'] == 1) {
  //         print('Timesheet updated successfully: ${responseData['message']}');
  //         return responseData; // Return the full response data
  //       } else {
  //         throw Exception('Failed to update timesheet: ${responseData['message']}');
  //       }
  //     } else {
  //       throw Exception('Error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error adding timesheet: $e');
  //     rethrow;
  //   }
  // }

  Future<Map<String, dynamic>> addTimesheet(Map<String, dynamic> requestBody) async {
    final String apiUrl = "https://devtashseet.proteam.co.in/backend/api/web/Timesheet/add";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Timesheet API Response: $responseData');
        return responseData;

      } else {
        throw Exception("Failed to add timesheet. Error: ${response.statusCode}");
      }
    } catch (e) {
      return {
        "success": 0,
        "message": "Error occurred: $e",
      };
    }
  }
}
