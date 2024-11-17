class TimesheetEntry {
  String? date;
  String? hrs;
  String? mstProjectsId;
  String? mstTimesheetsId;
  String? status;
  String? updatedUserId;
  String? userId;
  String? weekNo;
  String? year;

  TimesheetEntry({
    this.date,
    this.hrs,
    this.mstProjectsId,
    this.mstTimesheetsId,
    this.status,
    this.updatedUserId,
    this.userId,
    this.weekNo,
    this.year,
  });

  factory TimesheetEntry.fromJson(Map<String, dynamic> json) {
    return TimesheetEntry(
      date: json['date'] as String?,
      hrs: json['hrs'] as String?,
      mstProjectsId: json['mst_projects_id'] as String?,
      mstTimesheetsId: json['mst_timesheets_id'] as String?,
      status: json['status'] as String?,
      updatedUserId: json['updated_user_id'] as String?,
      userId: json['user_id'] as String?,
      weekNo: json['week_no'] as String?,
      year: json['year'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'hrs': hrs,
      'mst_projects_id': mstProjectsId,
      'mst_timesheets_id': mstTimesheetsId,
      'status': status,
      'updated_user_id': updatedUserId,
      'user_id': userId,
      'week_no': weekNo,
      'year': year,
    };
  }
}