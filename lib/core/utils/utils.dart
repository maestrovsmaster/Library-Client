import 'package:cloud_firestore/cloud_firestore.dart';
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

bool isNumeric(String text) {
  return double.tryParse(text) != null;
}

DateTime parseDate(dynamic value) {
  if (value == null) return DateTime.now(); // або throw
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  if (value is Map<String, dynamic> && value.containsKey('_seconds')) {
    return DateTime.fromMillisecondsSinceEpoch(value['_seconds'] * 1000);
  }
  throw Exception('Unsupported date format: $value');
}

String formatReviewDate(DateTime date) {
  return DateFormat('dd MMM yyyy', 'uk').format(date);
}