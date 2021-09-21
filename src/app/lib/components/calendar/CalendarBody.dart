import 'package:flutter/material.dart';

/// カレンダーのbody
class CalendarBody extends StatelessWidget {
  const CalendarBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        _buildHeader(theme.textTheme),
        Expanded(child: _buildCalendar()),
      ],
    );
  }

  /// ヘッダー部分をつくる
  Widget _buildHeader(TextTheme textTheme) {
    // 曜日のテキスト配列
    final weekdays = [
      'S',
      'M',
      'T',
      'W',
      'T',
      'F',
      'S',
    ];

    return Row(
      children: weekdays.map((wd) {
        return Expanded(child: _weekCell(wd, textTheme));
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

  /// 曜日のセル
  Widget _weekCell(String weekday, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Center(
        child: Text(
          weekday,
          style: textTheme.caption!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 0.1, color: Colors.grey),
      ),
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
