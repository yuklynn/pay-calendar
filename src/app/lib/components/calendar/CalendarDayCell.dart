import 'package:flutter/material.dart';

import '../../util/colors.dart';

/// カレンダーの日付セル
class CalendarDayCell extends StatelessWidget {
  final DateTime date;

  CalendarDayCell({
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16.0,
          backgroundColor: _getDateBackgroundColor(),
          child: Text(
            date.day.toString(),
            style: TextStyle(color: _getDateTextColor()),
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
        date.day == date.day) {
      // todo: 色
      return ThemeColor.asagao.color;
    }
    return Colors.transparent;
  }

  /// 日付の文字色取得
  Color _getDateTextColor() {
    final today = DateTime.now();
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == date.day) {
      return Colors.white;
    }
    return Colors.black;
  }
}
