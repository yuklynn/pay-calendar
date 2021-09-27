import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/calendar/CalendarModel.dart';
import '../../util/colors.dart';

/// カレンダーの日付セル
class CalendarDayCell extends StatelessWidget {
  final DateTime date;

  CalendarDayCell({
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final data = context.select<CalendarModel, CalendarDayCellData>(
      (model) => CalendarDayCellData(currentDate: model.currentDate),
    );

    return Column(
      children: [
        CircleAvatar(
          radius: 16.0,
          backgroundColor: _getDateBackgroundColor(),
          child: Text(
            date.day.toString(),
            style: TextStyle(color: _getDateTextColor(data.currentDate)),
          ),
        ),
        Container(),
      ],
    );
  }

  /// 日付の背景色取得
  Color _getDateBackgroundColor() {
    final today = DateTime.now();
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      // todo: 色
      return ThemeColor.asagao.color;
    }
    return Colors.transparent;
  }

  /// 日付の文字色取得
  Color _getDateTextColor(DateTime currentDay) {
    final today = DateTime.now();
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return Colors.white;
    }
    if (date.month != currentDay.month) return Colors.grey;
    return Colors.black;
  }
}

class CalendarDayCellData {
  final DateTime currentDate;

  CalendarDayCellData({
    required this.currentDate,
  });
}
