import 'package:flutter/material.dart';
import 'package:flutter_calendar_plugin/calendar_event.dart';

class CalendarUtils {

  /// holiday takes precedence over other colors
  static Color getCalendarEventColor(
      DateTime date,
      List<CalendarEvent> recurringEventsByWeekday,
      List<CalendarEvent> recurringEventsByDay,
      List<CalendarEvent> calendarEvents,
      ) {
    Color color = Colors.transparent;
    CalendarEvent holidayEvent;

    if (checkIfRecurringByWeekDay(date, recurringEventsByWeekday)) {
      recurringEventsByWeekday.forEach((element) {
        if (element.weekDay == date.weekday) {
          if (element.holiday) {
            holidayEvent = element;
            color = element.color;
          } else if (holidayEvent == null) {
            color = element.color;
          }
        }
      });
    }

    if (checkIfRecurringByDay(date, recurringEventsByDay)) {
      recurringEventsByDay.forEach((element) {
        if (element.dateTime.day == date.day) {
          if (element.holiday) {
            holidayEvent = element;
            color = element.color;
          } else if (holidayEvent == null) {
            color = element.color;
          }
        }
      });
    }

    if (checkIfCalendarEvent(date, calendarEvents)) {
      calendarEvents.forEach((element) {
        if (element.dateTime.day == date.day &&
            element.dateTime.month == date.month &&
            element.dateTime.year == date.year) {
          if (element.holiday) {
            holidayEvent = element;
            color = element.color;
          } else if (holidayEvent == null) {
            color = element.color;
          }
        }
      });
    }

    return color;
  }

  static Color getOnlyCalendarEventColor(
      DateTime date,
      CalendarEvent calendarEvent,
      ) {
    Color color = Colors.transparent;
    CalendarEvent holidayEvent;

    // if (checkIfCalendarEvent(date, calendarEvent)) {
    //   calendarEvent.forEach((element) {
    //     if (element.dateTime.day == date.day &&
    //         element.dateTime.month == date.month &&
    //         element.dateTime.year == date.year) {
    //       if (element.holiday) {
    //         holidayEvent = element;
    //         color = element.color;
    //       } else if (holidayEvent == null) {
    //         color = element.color;
    //       }
    //     }
    //   });
    // }

    if (checkIfCalendarEvent(date, [calendarEvent])) {
      if (calendarEvent.dateTime.day == date.day &&
          calendarEvent.dateTime.month == date.month &&
          calendarEvent.dateTime.year == date.year) {
        if (calendarEvent.holiday) {
          holidayEvent = calendarEvent;
          color = calendarEvent.color;
        } else if (holidayEvent == null) {
          color = calendarEvent.color;
        }

        //color = calendarEvent.color;
      }
    }

    return color;
  }

  /// Harin
  /// [date] calendar display date
  /// [event] event which contain date, color
  /// return bool, if event date is same as display date then return true else false
  static bool checkIfDisplayDateHasCalendarEvent(
      DateTime date, CalendarEvent event) {
    if (event == null) return false;
    if (event.dateTime.day == date.day &&
        event.dateTime.month == date.month &&
        event.dateTime.year == date.year) {
      return true;
    } else {
      return false;
    }
  }

  static bool checkIfRecurringByDay(
      DateTime date, List<CalendarEvent> eventList) {
    if (eventList == null) return false;
    return eventList?.indexWhere((event) => event.dateTime.day == date.day) !=
        -1;
  }

  static bool checkIfCalendarEvent(
      DateTime date, List<CalendarEvent> eventList) {
    if (eventList == null) return false;
    return eventList?.indexWhere((event) => (event.dateTime.day == date.day &&
        event.dateTime.month == date.month &&
        event.dateTime.year == date.year)) !=
        -1;
  }

  static bool checkIfRecurringByWeekDay(
      DateTime date, List<CalendarEvent> eventList) {
    if (eventList == null) return false;
    return eventList?.indexWhere((event) => event.weekDay == date.weekday) !=
        -1;
  }
}
