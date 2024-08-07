import 'package:flutter/material.dart';

class Event {
  final String title;
  final String subject;
  final String teacherUID;
  final TimeOfDay start;
  final TimeOfDay end;
  final bool? open;

  const Event(
    this.title,
    this.subject,
    this.teacherUID,
    this.start,
    this.end, {
    this.open = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subject': subject,
      'teacher_uid': teacherUID,
      'start': _timeOfDayToString(start),
      'end': _timeOfDayToString(end),
    };
  }

  String _timeOfDayToString(TimeOfDay time) {
    final String hour = time.hour.toString().padLeft(2, '0');
    final String minute = time.minute.toString().padLeft(2, '0');
    final String period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String startString() {
    return _timeOfDayToString(start);
  }

  String endString() {
    return _timeOfDayToString(end);
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
