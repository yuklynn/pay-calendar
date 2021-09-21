import 'package:flutter/material.dart';

import '../../util/colors.dart';

/// カレンダーの曜日セル
class CalendarWeekCell extends StatelessWidget {
  final Weekdays weekday;

  CalendarWeekCell({
    required this.weekday,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.caption!.copyWith(
          fontWeight: FontWeight.bold,
          color: weekday.textColor,
        );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Center(
        child: Text(
          weekday.name,
          style: textStyle,
        ),
      ),
      decoration: BoxDecoration(
        color: weekday.highlightColor,
        borderRadius: BorderRadius.circular(5),
        // border: Border.all(width: 0.1, color: Colors.grey),
      ),
    );
  }
}

enum Weekdays {
  sun,
  mon,
  tue,
  wed,
  thu,
  fri,
  sat,
}

extension WeekdaysExtension on Weekdays {
  String get name {
    switch (this) {
      case Weekdays.sun:
        return 'S';
      case Weekdays.mon:
        return 'M';
      case Weekdays.tue:
        return 'T';
      case Weekdays.wed:
        return 'W';
      case Weekdays.thu:
        return 'T';
      case Weekdays.fri:
        return 'F';
      case Weekdays.sat:
        return 'S';
      default:
        return '';
    }
  }

  Color get textColor {
    switch (this) {
      case Weekdays.sun:
        return ThemeColor.ume.color;
      case Weekdays.sat:
        return ThemeColor.asagao.color;
      default:
        return Colors.black;
    }
  }

  Color get highlightColor {
    switch (this) {
      case Weekdays.sun:
        return ThemeColor.ume.color.withOpacity(0.1);
      case Weekdays.sat:
        return ThemeColor.asagao.color.withOpacity(0.15);
      default:
        return Colors.black.withOpacity(0.05);
    }
  }
}
