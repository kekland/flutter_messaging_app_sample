import 'package:flutter/material.dart';

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

bool isSameYear(DateTime a, DateTime b) {
  return a.year == b.year;
}

bool isThisWeek({required BuildContext context, required DateTime dateTime}) {
  final now = DateTime.now();
  final weekday =
      now.weekday - MaterialLocalizations.of(context).firstDayOfWeekIndex;

  final firstDayOfWeek = now.subtract(
    Duration(days: weekday),
  );

  return dateTime.isAfter(firstDayOfWeek);
}

String formatDateOfTime({
  required BuildContext context,
  required DateTime dateTime,
}) {
  final localizations = MaterialLocalizations.of(context);

  return localizations.formatTimeOfDay(
    TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
  );
}

String formatAbsoluteShortDateTime({
  required BuildContext context,
  required DateTime dateTime,
}) {
  final localizations = MaterialLocalizations.of(context);

  if (isSameDay(dateTime, DateTime.now())) {
    // Example: 13:40
    return localizations.formatTimeOfDay(
      TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
    );
  }

  if (isThisWeek(context: context, dateTime: dateTime)) {
    // Example: Friday
    return localizations.formatFullDate(dateTime).split(',').first;
  }

  if (isSameYear(dateTime, DateTime.now())) {
    // Example: Feb 21
    return localizations.formatShortMonthDay(dateTime);
  }

  // Example: Feb 21, 2019
  return localizations.formatShortDate(dateTime);
}
