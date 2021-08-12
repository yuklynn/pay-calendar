import 'package:flutter/material.dart';

import '../common/CommonAppBar.dart';

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Calendar();
  }
}

class _Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildCalendar(theme.textTheme),
    );
  }

  AppBar _buildAppBar() {
    return CommonAppBar(
      title: Text('Calendar'),
    );
  }

  Widget _buildCalendar(TextTheme textTheme) {
    return Column(
      children: [
        _weekRow(textTheme),
        Expanded(child: _dateRow()),
        Expanded(child: _dateRow()),
        Expanded(child: _dateRow()),
        Expanded(child: _dateRow()),
        Expanded(child: _dateRow()),
        Expanded(child: _dateRow()),
      ],
    );
  }

  Widget _weekRow(TextTheme textTheme) {
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

  Widget _dateRow() {
    return Row(
      children: [
        Expanded(child: _dateCell()),
        Expanded(child: _dateCell()),
        Expanded(child: _dateCell()),
        Expanded(child: _dateCell()),
        Expanded(child: _dateCell()),
        Expanded(child: _dateCell()),
        Expanded(child: _dateCell()),
      ],
    );
  }

  Widget _dateCell() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.1, color: Colors.grey),
      ),
    );
  }
}
