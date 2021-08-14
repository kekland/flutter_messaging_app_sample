import 'package:flutter/material.dart';

bool isToday(DateTime dateTime) {
  final now = DateTime.now();

  return dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day;
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

bool isThisYear(DateTime dateTime) {
  final now = DateTime.now();

  return dateTime.year == now.year;
}

String formatAbsoluteShortDateTime({
  required BuildContext context,
  required DateTime dateTime,
}) {
  final localizations = MaterialLocalizations.of(context);

  if (isToday(dateTime)) {
    // Example: 13:40
    return localizations.formatTimeOfDay(
      TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
    );
  }

  if (isThisWeek(context: context, dateTime: dateTime)) {
    // Example: Friday
    return localizations.formatFullDate(dateTime).split(',').first;
  }

  if (isThisYear(dateTime)) {
    // Example: Feb 21
    return localizations.formatShortMonthDay(dateTime);
  }

  // Example: Feb 21, 2019
  return localizations.formatShortDate(dateTime);
}
