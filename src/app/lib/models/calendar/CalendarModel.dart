import 'package:flutter/material.dart';

/// カレンダー画面のModel
class CalendarModel with ChangeNotifier {
  late PageController pageController; // PageViewのコントローラー
  List<DateTime> dateRange = []; // 日付の範囲
  late DateTime currentDate; // 現在の日付

  /// コンストラクタ
  CalendarModel() {
    _init();
  }

  /// 初期処理
  void _init() {
    // コントローラー生成
    pageController = PageController(initialPage: 12);

    // 日付範囲取得
    final today = DateTime.now();
    for (var i = 0; i < 24; i++) {
      final date = DateTime(today.year - 1, today.month + i);
      dateRange.add(date);
    }

    /// 初期表示の日付は今月
    currentDate = dateRange[12];

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
    currentDate = dateRange[index];
    try {
      notifyListeners();
    } catch (_) {}
  }
}
