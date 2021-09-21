import 'package:flutter/material.dart';

import 'CalendarWeekCell.dart';

/// カレンダーのbody
class CalendarBody extends StatelessWidget {
  const CalendarBody({Key? key}) : super(key: key);

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
          crossAxisCount: 7,
          childAspectRatio: width / height,
          children: List.filled(7 * 6, _dateCell()),
        );
      },
    );
  }

  /// 日付のセル
  Widget _dateCell() {
    // todo: 中身
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.1, color: Colors.grey),
      ),
    );
  }
}
