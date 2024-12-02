import 'dart:convert';
import 'package:first/LoginResponse.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'models/LoginModule.dart';

class ApiService {
   //final String baseUrl = 'https://devtashseet.proteam.co.in/backend/api/web/validate_login';
   final String baseUrl = 'https://renewtimesheet.proteam.co.in/backend/api/web/validate_login';

  Future<LoginResponse?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl'); // Ensure this is correct
    try {
      final request = http.MultipartRequest('POST', url);
      request.fields['email'] = username;
      request.fields['password'] = password;
      request.headers['Cookie'] = 'ci_session=your_dynamic_session_token'; // Avoid hardcoding

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      print('Response status: ${responseBody.statusCode}');
      print('Response body: ${responseBody.body}');

      if (responseBody.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(responseBody.body);

        if (jsonResponse['success'] == 1) {
          List<dynamic> delegateData = jsonResponse['data'][0]['delegated_emp'];
          List<DelegateEmployee> delegates = delegateData
              .map((dynamic emp) => DelegateEmployee.fromJson(emp))
              .toList();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('delegatedEmployees', jsonEncode(delegates.map((e) => e.toJson()).toList()));
          print("Delegate employee details saved successfully.");

          return LoginResponse.fromJson(jsonResponse);
        } else {
          print("Error: ${jsonResponse['message']}");
        }
      } else {
        print('Failed to log in. Status code: ${responseBody.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error occurred during login: $e');
      print('Stack trace: $stackTrace');
    }
    return null;
  }

}