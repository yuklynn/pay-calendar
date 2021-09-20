import 'package:flutter/material.dart';

/// ノートのAppBarのモデル
class NoteAppBarModel with ChangeNotifier {
  /// スクロールの基準となるキー
  late GlobalKey scrollKey;

  /// スクロールのコントローラー
  late ScrollController scrollController;

  /// AppBarが閉じているかどうか
  bool collapsed = false;

  /// コンストラクタ
  NoteAppBarModel() {
    _init();
  }

  /// 初期処理
  void _init() {
    scrollKey = GlobalKey();

    scrollController = ScrollController();
    scrollController.addListener(_onScrolled);
  }

  /// 破棄処理
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  /// 画面スクロール時の処理
  void _onScrolled() {
    // スクロール基準の位置取得
    final border = scrollKey.currentContext?.findRenderObject();
    if (border == null) return;
    final offset = (border as RenderBox).localToGlobal(Offset.zero);
    final topLimit = kToolbarHeight + AppBar().preferredSize.height;

    // ヘッダー開閉フラグの切り替え
    if (offset.dy < topLimit) {
      if (!collapsed) {
        collapsed = true;
        try {
          notifyListeners();
        } catch (_) {}
      }
    }
    if (offset.dy > topLimit) {
      if (collapsed) {
        collapsed = false;
        try {
          notifyListeners();
        } catch (_) {}
      }
    }
  }
}
