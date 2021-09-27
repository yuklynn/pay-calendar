import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/calendar/CalendarModel.dart';
import 'CalendarDayCell.dart';
import 'CalendarWeekCell.dart';

/// カレンダーのbody
class CalendarBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = context.select<CalendarModel, CalendarBodyData>(
      (model) => CalendarBodyData(
        dateList: model.dateListOnCurrentMonth,
      ),
    );

    return Column(
      children: [
        const SizedBox(height: 8.0),
        _buildHeader(theme.textTheme),
        const SizedBox(height: 8.0),
        Expanded(child: _buildCalendar(data.dateList)),
      ],
    );
  }

  /// ヘッダー部分をつくる
  Widget _buildHeader(TextTheme textTheme) {
    return Row(
      children: Weekdays.values.map((wd) {
        return Expanded(child: CalendarWeekCell(weekday: wd));
      }).toList(),
    );
  }

  /// カレンダー部分をつくる
  Widget _buildCalendar(List<DateTime> dateList) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth / 7;
        final height = constraints.maxHeight / 6;
        return GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 7,
          childAspectRatio: width / height,
          children: List.generate(
            dateList.length,
            (index) => CalendarDayCell(
              date: dateList[index],
            ),
          ),
        );
      },
    );
  }
}

class CalendarBodyData {
  List<DateTime> dateList;

  CalendarBodyData({
    required this.dateList,
  });
}
