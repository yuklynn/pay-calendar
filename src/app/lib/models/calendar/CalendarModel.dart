import 'package:flutter/material.dart';

/// カレンダー画面のModel
class CalendarModel with ChangeNotifier {
  late PageController pageController; // PageViewのコントローラー
  List<DateTime> dateRange = []; // 日付の範囲
  late DateTime currentDate; // 現在の日付
  int currentIndex = 12;
  List<DateTime> dateListOnPreviousMonth = []; // 前月の日付リスト
  List<DateTime> dateListOnCurrentMonth = []; // 今月の日付リスト
  List<DateTime> dateListOnNextMonth = []; // 来月の日付リスト

  /// コンストラクタ
  CalendarModel() {
    _init();
  }

  /// 初期処理
  void _init() {
    // コントローラー生成
    pageController = PageController(initialPage: 12);

    // 日付範囲取得
    // 今月から前後1年間
    final today = DateTime.now();
    for (var i = 0; i < 24; i++) {
      final date = DateTime(today.year - 1, today.month + i);
      dateRange.add(date);
    }

    // 初期表示の日付は今月
    currentDate = DateTime(
      dateRange[currentIndex].year,
      dateRange[currentIndex].month,
      today.day,
    );

    // 前月~今月の日付リストを取得
    _getDateListOnPreviousMonth();
    _getDateListOnCurrentMonth();
    _getDateListOnNextMonth();

    try {
      notifyListeners();
    } catch (_) {}
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  /// ページ変更時の処理
  void onPageChanged(int index) {
    // 表示中の日付を変更
    currentDate = DateTime(
      dateRange[index].year,
      dateRange[index].month,
      currentDate.day,
    );

    // 前月~今月の日付リストを取得
    // 進むとき
    if (index > currentIndex) {
      dateListOnPreviousMonth = [...dateListOnCurrentMonth];
      dateListOnCurrentMonth = [...dateListOnNextMonth];
      _getDateListOnNextMonth();
    }
    // 戻るとき
    else {
      dateListOnNextMonth = [...dateListOnCurrentMonth];
      dateListOnCurrentMonth = [...dateListOnPreviousMonth];
      _getDateListOnPreviousMonth();
    }

    currentIndex = index;
    try {
      notifyListeners();
    } catch (_) {}
  }

  /// 前月の日付リストを取得
  void _getDateListOnPreviousMonth() {
    final begin = DateTime(currentDate.year, currentDate.month - 1, 1);
    final beginWeekDay = begin.weekday % 7; // 日曜日が0になるようにする
    final firstDay = DateTime(
      begin.year,
      begin.month,
      begin.day - beginWeekDay,
    );
    dateListOnPreviousMonth.clear();
    for (var i = 0; i < 7 * 5; i++) {
      final date = DateTime(firstDay.year, firstDay.month, firstDay.day + i);
      dateListOnPreviousMonth.add(date);
    }
  }

  /// 来月の日付リストを取得
  void _getDateListOnCurrentMonth() {
    final begin = DateTime(currentDate.year, currentDate.month, 1);
    final beginWeekDay = begin.weekday % 7; // 日曜日が0になるようにする
    final firstDay = DateTime(
      begin.year,
      begin.month,
      begin.day - beginWeekDay,
    );
    dateListOnCurrentMonth.clear();
    for (var i = 0; i < 7 * 5; i++) {
      final date = DateTime(firstDay.year, firstDay.month, firstDay.day + i);
      dateListOnCurrentMonth.add(date);
    }
  }

  /// 今月の日付リストを取得
  void _getDateListOnNextMonth() {
    final begin = DateTime(currentDate.year, currentDate.month + 1, 1);
    final beginWeekDay = begin.weekday % 7; // 日曜日が0になるようにする
    final firstDay = DateTime(
      begin.year,
      begin.month,
      begin.day - beginWeekDay,
    );
    dateListOnNextMonth.clear();
    for (var i = 0; i < 7 * 5; i++) {
      final date = DateTime(firstDay.year, firstDay.month, firstDay.day + i);
      dateListOnNextMonth.add(date);
    }
  }
}
