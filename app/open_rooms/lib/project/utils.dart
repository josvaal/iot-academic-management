// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:open_rooms/project/classes/date_day.dart';
import 'package:open_rooms/project/classes/event.dart';

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

DateTime roundStartTime(DateTime dateTime) {
  int roundedHours = dateTime.minute >= 30 ? dateTime.hour + 1 : dateTime.hour;

  return DateTime(
    dateTime.year,
    dateTime.month,
    dateTime.day,
    roundedHours,
    0,
  );
}

DateTime roundEndTime(DateTime dateTime) {
  int adjustedHours = dateTime.hour + 2;
  int roundedHours = dateTime.minute >= 30 ? adjustedHours + 1 : adjustedHours;

  return DateTime(
    dateTime.year,
    dateTime.month,
    dateTime.day,
    roundedHours,
    0,
  );
}

DateDay? parseDateDay(DataSnapshot child) {
  try {
    final year = int.parse(child.child("year").value.toString());
    final month = int.parse(child.child("month").value.toString());
    final day = int.parse(child.child("day").value.toString());
    return DateDay(year, month, day);
  } catch (e) {
    print('Error parsing DateDay: $e');
    return null;
  }
}

Event? parseEvent(DataSnapshot child) {
  try {
    final startTime = TimeOfDay(
      hour: int.parse(child.child("start_hour").value.toString()),
      minute: int.parse(child.child("start_minute").value.toString()),
    );
    final endTime = TimeOfDay(
      hour: int.parse(child.child("end_hour").value.toString()),
      minute: int.parse(child.child("end_minute").value.toString()),
    );
    final title = child.child("title").value.toString();
    final subject = child.child("subject").value.toString();
    final teacherUID = child.child("teacher_uid").value.toString();

    return Event(title, subject, teacherUID, startTime, endTime);
  } catch (e) {
    print('Error parsing Event: $e');
    return null;
  }
}
