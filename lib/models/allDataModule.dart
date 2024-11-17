// timesheet_data_model.dart
class TimesheetData12 {
  final String mstProjectsId;
  final String mstTimesheetsId;
  final String year;
  final String weekNo;
  final String date;
  final String hrs;
  final String status;

  TimesheetData12({
    required this.mstProjectsId,
    required this.mstTimesheetsId,
    required this.year,
    required this.weekNo,
    required this.date,
    required this.hrs,
    required this.status,
  });

  factory TimesheetData12.fromJson(Map<String, dynamic> json) {
    return TimesheetData12(
      mstProjectsId: json['mst_projects_id'] ?? '',
      mstTimesheetsId: json['mst_timesheets_id'] ?? '',
      year: json['year'] ?? '',
      weekNo: json['week_no'] ?? '',
      date: json['date'] ?? '',
      hrs: json['hrs'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
