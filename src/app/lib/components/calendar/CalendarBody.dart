import 'package:flutter/material.dart';

import 'CalendarDayCell.dart';
import 'CalendarWeekCell.dart';

/// カレンダーのbody
class CalendarBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 8.0),
        _buildHeader(theme.textTheme),
        const SizedBox(height: 8.0),
        Expanded(child: _buildCalendar()),
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
  Widget _buildCalendar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth / 7;
        final height = constraints.maxHeight / 6;
        return GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 7,
          childAspectRatio: width / height,
          children: List.filled(7 * 6, CalendarDayCell(date: DateTime.now())),
        );
      },
    );
  }
}
