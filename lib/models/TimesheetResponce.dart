// timesheet_response_model.dart
import 'package:first/TimesheetData.dart';

class TimesheetResponse {
  final int success;
  final List<TimesheetData> data;
  final String message;

  TimesheetResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory TimesheetResponse.fromJson(Map<String, dynamic> json) {
    return TimesheetResponse(
      success: json['success'] ?? 0,
      data: (json['data'] as List)
          .map((item) => TimesheetData.fromJson(item))
          .toList(),
      message: json['message'] ?? '',
    );
  }
}
