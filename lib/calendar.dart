import 'package:flutter/material.dart';
import 'package:flutter_calendar_plugin/calendar_date_element.dart';
import 'package:flutter_calendar_plugin/calendar_event.dart';
import 'package:flutter_calendar_plugin/calendar_utils.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  /// [startExpanded] if true => show full calendar else => show half calendar
  final bool startExpanded;

  /// [maxEventDots] display max event dot, after that we show plus icon,
  /// which indicate date has extra events
  /// default value is 2 (set in constructor)
  final int maxEventDots;

  /// off
  //final List<String> off;

  /// show/hide previous/next month day
  /// default value is false
  //final bool shouldShowPreviousNextMonthsDay;

  /// [onDateSelected] on date click function
  final Function(DateTime) onDateSelected;

  /// [onPreviousMonth] when click on previous month
  final Function(DateTime) onPreviousMonth;

  /// [onNextMonth] when click on next month
  final Function(DateTime) onNextMonth;

  /// [recurringEventsByWeekday] repeat event on every week
  final List<CalendarEvent> recurringEventsByWeekday;

  /// [calendarEvents] event list for specific date
  final List<CalendarEvent> calendarEvents;

  /// [recurringEventsByDay] repeat event on specific day like monday, tuesday...
  final List<CalendarEvent> recurringEventsByDay;

  /// [headerTitleColor] calendar title color {Jan 2021}
  final Color headerTitleColor;
  /// [weekDayTitleColor] calendar day title color {sun, mon, tue..}
  final Color weekDayTitleColor;

  final WeekDayStyle weekDayStyle;

  final bool shouldShowHeader;

  /// [language] calendar language, default language is english
  final String language;

  const Calendar({
    Key key,
    this.startExpanded = true,
    this.maxEventDots = 2,
    //this.shouldShowPreviousNextMonthsDay = false,
    //this.off,
    this.onDateSelected,
    this.onPreviousMonth,
    this.onNextMonth,
    this.calendarEvents,
    this.recurringEventsByWeekday,
    this.recurringEventsByDay,
    this.headerTitleColor,
    this.weekDayTitleColor,
    this.weekDayStyle,
    this.shouldShowHeader,
    this.language,
  }) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar>
    with SingleTickerProviderStateMixin {
  /// by default select today's date
  DateTime _selectedDate = DateTime.now();
  List<DateTime> _weekDayDateTimeList;

  bool _expanded;
  int _maxEventDots;
  //bool _shouldShowPreviousNextMonthsDate = false;

  DateTime _startOfMonth;
  List<DateTime> _monthDateTimeList;
  List<List<DateTime>> _calendarData;

  Color _headerTitleColor;
  Color _weekDayTitleColor;
  WeekDayStyle _weekDayStyle;
  bool _shouldShowHeader;

  String _language;

  @override
  void initState() {
    _expanded = widget.startExpanded;
    _maxEventDots = widget.maxEventDots;

    if(widget.headerTitleColor != null) {
      _headerTitleColor = widget.headerTitleColor;
    }else{
      _headerTitleColor = Colors.black;
    }
    if(widget.weekDayTitleColor != null) {
      _weekDayTitleColor = widget.weekDayTitleColor;
    }else{
      _weekDayTitleColor = Colors.black;
    }

    if(widget.shouldShowHeader != null){
      _shouldShowHeader = widget.shouldShowHeader;
    }else{
      _shouldShowHeader = true;
    }

    if(widget.weekDayStyle != null){
      _weekDayStyle = widget.weekDayStyle;
    }else{
      _weekDayStyle = WeekDayStyle.MEDIUM;
    }

    if(widget.language != null){
      _language = widget.language;
    }else{
      //_language = "en_US";
      _language = "en";
    }

    //_shouldShowPreviousNextMonthsDate = widget.shouldShowPreviousNextMonthsDay;
    _initCalendar();
    super.initState();
  }

  void _initCalendar() {
    _weekDayDateTimeList = [];
    _monthDateTimeList = [];
    _calendarData = [];

    if (_selectedDate.day == 1) {
      _startOfMonth = _selectedDate;
    } else {
      _startOfMonth = _selectedDate.subtract(
        Duration(days: _selectedDate.day - 1),
      );
    }

    if (_startOfMonth.day != DateTime.sunday) {
      _startOfMonth = _startOfMonth.subtract(
        Duration(days: _startOfMonth.weekday),
      );
    }

    for (int i = 0;; i = i + 7) {
      DateTime date = _startOfMonth.add(Duration(days: i));
      List<DateTime> tempDateList = [];

      for (int i = 0; i < 7; i++) {
        tempDateList.add(date.add(Duration(days: i)));
      }
      _calendarData.add(tempDateList);
      if (_startOfMonth.add(Duration(days: i + 7)).month !=
          _selectedDate.month) {
        break;
      }
    }

    DateTime weekDayCalendar;
    if (_selectedDate.weekday == DateTime.sunday) {
      weekDayCalendar = _selectedDate;
    } else {
      weekDayCalendar = _selectedDate.subtract(Duration(
        days: _selectedDate.weekday,
      ));
    }
    for (int i = 0; i < 7; i++) {
      _weekDayDateTimeList?.add(weekDayCalendar.add(Duration(days: i)));
    }

    for (int i = 0;; i++) {
      DateTime date = _startOfMonth.add(Duration(days: i));
      if (date.month != _selectedDate.month) {
        break;
      }
      _monthDateTimeList.add(date);
    }
  }

  void _nextMonth() {
    if (_selectedDate.month == DateTime.december) {
      _selectedDate = DateTime(
        _selectedDate.year + 1,
        1,
        _selectedDate.day,
      );
    } else {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month + 1,
        _selectedDate.day,
      );
    }
    setState(() {
      _initCalendar();
    });
  }

  void _previousMonth() {
    if (_selectedDate.month == DateTime.january) {
      _selectedDate = DateTime(
        _selectedDate.year - 1,
        12,
        _selectedDate.day,
      );
    } else {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month - 1,
        _selectedDate.day,
      );
    }
    setState(() {
      _initCalendar();
    });
  }

  void _selectDate(DateTime date) {
    _selectedDate = date;
    setState(() {
      _initCalendar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: double.infinity,
          // padding: EdgeInsets.all(
          //   8,
          // ),
          margin: EdgeInsets.zero,
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   boxShadow: [
          //     BoxShadow(
          //       blurRadius: 25,
          //       color: AppConstant.blackShadow,
          //       offset: Offset(
          //         0,
          //         15,
          //       ),
          //       spreadRadius: 13,
          //     ),
          //   ],
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// widget with next and previous button, current month
              _shouldShowHeader ? header() : Container(),
              Divider(
                color: Colors.grey,
                height: 1,
              ),
              // SizedBox(
              //   height: 22,
              // ),
              AnimatedSize(
                vsync: this,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  child: _expanded
                      ? Container(
                    child: Table(
                      defaultVerticalAlignment:
                      TableCellVerticalAlignment.middle,
                      children: [

                        /// week day name
                        weekDayNameRow(),

                        /// dates of month
                        for (List<DateTime> dateList
                        in _calendarData) ...[
                          // TableRow(
                          //   children: [
                          //     for (int i = 0; i < 7; i++)
                          //       Container(
                          //         height: 5,
                          //       ),
                          //   ],
                          // ),
                          TableRow(
                            children: dateList.map((date) {
                              return Column(
                                children: <Widget>[
                                  CalendarDateElement(
                                    date: date.day,
                                    // showNextPreviousMonthDate:
                                    //     _shouldShowPreviousNextMonthsDate,
                                    //off: widget.off,
                                    today:
                                    date.day == DateTime.now().day &&
                                        date.month ==
                                            DateTime.now().month,
                                    fade:
                                    date.month != _selectedDate.month,
                                    selected: date.day ==
                                        _selectedDate.day &&
                                        date.month == _selectedDate.month,
                                    onTap: () {
                                      _selectDate(date);
                                      if (widget.onDateSelected != null) {
                                        widget.onDateSelected(date);
                                      }
                                    },
                                  ),
                                  // SizedBox(
                                  //   height: 5,
                                  // ),
                                  /// event dot
                                  // Container(
                                  //   width: 6,
                                  //   height: 6,
                                  //   decoration: BoxDecoration(
                                  //     shape: BoxShape.circle,
                                  //     color: CalendarUtils
                                  //         .getCalendarEventColor(
                                  //       date,
                                  //       widget.recurringEventsByWeekday,
                                  //       widget.recurringEventsByDay,
                                  //       widget.calendarEvents,
                                  //     ),
                                  //   ),
                                  // ),
                                  eventDots(date, widget.calendarEvents),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.center,
                                  //   children: widget.calendarEvents
                                  //       .map((event) {
                                  //     return Container(
                                  //       width: 6,
                                  //       height: 6,
                                  //       margin: EdgeInsets.fromLTRB(
                                  //           1, 0, 1, 0),
                                  //       decoration: BoxDecoration(
                                  //         shape: BoxShape.circle,
                                  //         color: CalendarUtils
                                  //             .getCalendarEventColor(
                                  //           date,
                                  //           widget
                                  //               .recurringEventsByWeekday,
                                  //           widget.recurringEventsByDay,
                                  //           widget.calendarEvents,
                                  //         ),
                                  //       ),
                                  //     );
                                  //   }).toList(),
                                  // ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  )
                      : Table(
                    defaultVerticalAlignment:
                    TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: _weekDayDateTimeList.map((day) {
                          String dayInitial =
                          DateFormat('E').format(day).substring(0, 1);
                          return Center(
                            child: Text(
                              '$dayInitial',
                              style: TextStyle(
                                color:
                                day.weekday == DateTime.now().weekday
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      TableRow(
                        children: [
                          for (int i = 0; i < 7; i++)
                            Container(
                              height: 5,
                            ),
                        ],
                      ),
                      TableRow(
                        children: _weekDayDateTimeList.map((date) {
                          return Column(
                            children: <Widget>[
                              CalendarDateElement(
                                date: date.day,
                                today: date.day == DateTime.now().day &&
                                    date.month == DateTime.now().month,
                                fade: date.month != _selectedDate.month,
                                // showNextPreviousMonthDate:
                                //     _shouldShowPreviousNextMonthsDate,
                                selected: date.day == _selectedDate.day &&
                                    date.month == _selectedDate.month,
                                onTap: () {
                                  _selectDate(date);
                                  if (widget.onDateSelected != null) {
                                    widget.onDateSelected(date);
                                  }
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                  CalendarUtils.getCalendarEventColor(
                                    date,
                                    widget.recurringEventsByWeekday,
                                    widget.recurringEventsByDay,
                                    widget.calendarEvents,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 1,
              ),
            ],
          ),
        ),
        // Center(
        //   child: GestureDetector(
        //     onTap: () {
        //       setState(() {
        //         _expanded = !_expanded;
        //       });
        //     },
        //     child: Container(
        //       width: 66,
        //       height: 30,
        //       color: AppConstant.lighterBlue,
        //       child: Icon(
        //         _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        //         color: AppConstant.blue,
        //         size: 18,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget header(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 50.0,
            height: 50.0,
            decoration: new BoxDecoration(
              color: Colors.purpleAccent,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                _previousMonth();
                if (widget.onPreviousMonth != null) {
                  widget.onPreviousMonth(_selectedDate);
                }
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            '${DateFormat('MMMM yyyy').format(_selectedDate)}',
            style: TextStyle(
              color: _headerTitleColor,
              fontSize: 20,
            ),
          ),
          Container(
            width: 50.0,
            height: 50.0,
            decoration: new BoxDecoration(
              color: Colors.purpleAccent,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                _nextMonth();
                if (widget.onNextMonth != null) {
                  widget.onNextMonth(_selectedDate);
                }
              },
              icon: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow weekDayNameRow(){
    return TableRow(
      children: _weekDayDateTimeList.map((day) {
        // String dayInital = DateFormat(
        //     'E') // E = S,M,T...     EEE= Sun,MON,TUE...
        //     .format(day);
            //.substring(0, 3);

        //await initializeDateFormatting("ar_SA", null);

        String dayInitial = "";
        switch(_weekDayStyle){
          case WeekDayStyle.SHORT:
            //dayInitial = DateFormat('E', _language).format(day);
            dayInitial = DateFormat('E').format(day);
            break;
          case WeekDayStyle.MEDIUM:
            //dayInitial = DateFormat('EEE', _language).format(day);
            dayInitial = DateFormat('EEE').format(day);
            break;
        }

        return Center(
          child: Text(
            '$dayInitial',
            style: TextStyle(
              // color: day.weekday ==
              //         DateTime.now().weekday
              //     ? AppConstant.blue
              //     : AppConstant.lightGrey,
              color: _weekDayTitleColor,
              fontSize: 16,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget eventDots(DateTime date, List<CalendarEvent> events) {
    List<Widget> widgets = [];

    for (int i = 0; i < events.length; i++) {
      if (widgets.length == _maxEventDots) {
        if (CalendarUtils.checkIfDisplayDateHasCalendarEvent(date, events[i])) {
          widgets.add(Container(
            width: 6,
            height: 6,
            child: Icon(Icons.add, size: 6, color: Colors.black),
          ));
        }
        break;
      } else {
        if (CalendarUtils.checkIfDisplayDateHasCalendarEvent(date, events[i])) {
          widgets.add(Container(
            width: 6,
            height: 6,
            margin: EdgeInsets.fromLTRB(1, 0, 1, 0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: CalendarUtils.getOnlyCalendarEventColor(
                //   date,
                //   events[i],
                // ),
                color: events[i].color),
          ));
        }
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets,
    );
  }
}


enum WeekDayStyle{
  SHORT, MEDIUM
}