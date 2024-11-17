import 'package:intl/intl.dart';

List<String> getDatesForFinancialWeek(int financialYear, int weekNumber) {
  List<String> dates = [];

  // Set the start of the financial year to April 1st
  DateTime startOfFinancialYear = DateTime(financialYear, 4, 1);

  // Adjust to the correct financial year if the current date is before April 1
  if (DateTime.now().isBefore(startOfFinancialYear)) {
    startOfFinancialYear = DateTime(financialYear - 1, 4, 1);
  }

  // Move to the requested week number within the financial year
  DateTime weekStartDate = startOfFinancialYear.add(Duration(days: (weekNumber - 1) * 7));

  // Set up date format
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  for (int i = 0; i < 7; i++) {
    dates.add(dateFormat.format(weekStartDate.add(Duration(days: i))));
  }

  return dates;
}
