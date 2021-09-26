import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../components/calendar/CalendarBody.dart';
import '../components/common/CommonAppBar.dart';
import '../models/calendar/CalendarModel.dart';

/// カレンダー画面
class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CalendarModel(),
        )
      ],
      builder: (context, _) {
        final data = context.select<CalendarModel, CalendarData>(
          (model) => CalendarData(
            pageController: model.pageController,
            dateRange: model.dateRange,
            currentDate: model.currentDate,
            onPageChanged: model.onPageChanged,
          ),
        );

        return Scaffold(
          appBar: CommonAppBar(
            title: Text(getShownMonthStr(data.currentDate)),
          ),
          body: PageView.builder(
            controller: data.pageController,
            itemCount: data.dateRange.length,
            itemBuilder: (context, index) => CalendarBody(),
            onPageChanged: data.onPageChanged,
          ),
        );
      },
    );
  }

  /// 表示している月の文字列を取得する
  String getShownMonthStr(DateTime date) {
    return DateFormat.yMMMM().format(date);
  }
}

class CalendarData {
  final PageController pageController;
  final List<DateTime> dateRange;
  final DateTime currentDate;
  final void Function(int) onPageChanged;

  CalendarData({
    required this.pageController,
    required this.dateRange,
    required this.currentDate,
    required this.onPageChanged,
  });
}
