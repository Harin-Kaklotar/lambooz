import 'package:flutter/material.dart';

class CalendarDateElement extends StatelessWidget {
  final int date;
  final bool today;

  /// date other than current month
  /// true : if date is previous or next month's
  /// false: if date is current month's
  final bool fade;
  final Function onTap;
  final bool selected;
  //final List<String> off;

  //final bool showNextPreviousMonthDate;

  const CalendarDateElement({
    Key key,
    @required this.date,
    this.today = false,
    this.fade = false,
    this.onTap,
    this.selected = false,
    //@required this.showNextPreviousMonthDate,
    //this.off,
  })  : assert(date != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {

    return today
        ? GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue.shade100,
          border: Border.all(
            color:
            today && selected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          '$date',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ),
    )
        : (selected)
        ? GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // color: AppConstant.lighter_blue,
          border: Border.all(
            color: Colors.blue,
            width: 2,
          ),
        ),
        child: Text(
          '$date',
          style: TextStyle(
              color: Colors.blue,
              ),
        ),
      ),
    )
        : GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: Text(
          '$date',
          style: TextStyle(
            color:
            fade ? Colors.grey : Colors.black,
          ),
        ),
      ),
    );
  }
}
