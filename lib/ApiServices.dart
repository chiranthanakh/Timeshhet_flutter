import 'dart:convert';
import 'package:first/LoginResponse.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'models/LoginModule.dart';

class ApiService {
  final String baseUrl = 'https://devtashseet.proteam.co.in/backend/api/web/validate_login';

  Future<LoginResponse?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl');
    try {
    final request = http.MultipartRequest('POST', url);
    request.fields['email'] = username;
    request.fields['password'] = password;
    request.headers['Cookie'] = 'ci_session=73ae94e0879a37cb664d4b1e57a4c10b13a8b9ea';
    final response = await request.send();
    final responseBody = await http.Response.fromStream(response);

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
        } else {
          print("Error: ${jsonResponse['message']}");
        }

        return LoginResponse.fromJson(jsonResponse);
      } else {
        print('Failed to log in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }
}