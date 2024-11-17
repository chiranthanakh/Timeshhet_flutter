class TimesheetData {
  final String mstProjectsId;
  final String mstTimesheetsId;
  final String year;
  final String weekNo;
  final String date;
  final String hrs;
  final String status;

  TimesheetData({
    required this.mstProjectsId,
    required this.mstTimesheetsId,
    required this.year,
    required this.weekNo,
    required this.date,
    required this.hrs,
    required this.status,
  });

  @override
  String toString() {
    return 'TimesheetData(mstProjectsId: $mstProjectsId, mstTimesheetsId: $mstTimesheetsId, year: $year, weekNo: $weekNo, date: $date, hrs: $hrs, status: $status)';
  }

  factory TimesheetData.fromJson(Map<String, dynamic> json) {
    return TimesheetData(
      mstProjectsId: json['mst_projects_id'] ?? '',
      mstTimesheetsId: json['mst_timesheets_id'] ?? '',
      year: json['year'] ?? '',
      weekNo: json['week_no'] ?? '',
      date: json['date'] ?? '',
      hrs: json['hrs'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "mst_projects_id": mstProjectsId,
      "mst_timesheets_id": mstTimesheetsId,
      "year": year,
      "week_no": weekNo,
      "date": date,
      "hrs": hrs,
      "status": status,
    };
  }
}
