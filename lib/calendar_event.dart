
import 'package:flutter/material.dart';

class CalendarEvent {
  DateTime dateTime;
  int weekDay;
  final Color color;
  final bool holiday;

  CalendarEvent.fromDateTime({
    @required this.dateTime,
    this.color = Colors.blue,
    this.holiday = false,
  });

  CalendarEvent.fromWeekDay({
    @required this.weekDay,
    this.color = Colors.blue,
    this.holiday = false,
  });
}