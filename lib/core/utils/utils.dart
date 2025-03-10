import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Calculates the age of an item based on its release year.
int calculateItemAge(int releaseYear) {
  final currentYear = DateTime.now().year;
  if (releaseYear > currentYear) {
    return 0;
  }
  return currentYear - releaseYear;
}


/// Formats a [DateTime] object into a human-readable English date format.
///
/// Example output: "June 15, 2024"
String formatDateToEnglishString(DateTime dateTime) {
  return DateFormat('MMMM d, yyyy', 'en_US').format(dateTime);
}