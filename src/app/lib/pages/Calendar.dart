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
            currentIndex: model.currentIndex,
            onPageChanged: model.onPageChanged,
            jumpToToday: model.jumpToToday,
          ),
        );

        return Scaffold(
          appBar: CommonAppBar(
            title: Text(getShownMonthStr(data.currentDate)),
            actions: [
              if (data.currentIndex != 12)
                TextButton.icon(
                  onPressed: data.jumpToToday,
                  icon: const Icon(Icons.today),
                  label: const Text('TODAY'), // todo: 文言
                ),
            ],
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
  final int currentIndex;
  final void Function(int) onPageChanged;
  final VoidCallback jumpToToday;

  CalendarData({
    required this.pageController,
    required this.dateRange,
    required this.currentDate,
    required this.currentIndex,
    required this.onPageChanged,
    required this.jumpToToday,
  });
}
