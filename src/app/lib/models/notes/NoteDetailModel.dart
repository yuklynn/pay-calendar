import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../actions/notes/isar_wrapper.dart';
import '../../actions/notes/navigation.dart';
import '../../types/NoteType.dart';

/// ノート詳細画面のModel
class NoteDetailModel with ChangeNotifier {
  NoteType note; // ノート
  bool headerCollapsed = false; // ヘッダーが閉じているか
  late GlobalKey borderKey; // ボーダーのKey
  late ScrollController scrollController; // スクロールのコントローラー
  bool loading = false; // ノートの詳細をロード済みか

  /// コンストラクタ
  NoteDetailModel({
    required this.note,
  }) {
    // 初期処理
    _init();
  }

  /// 初期処理
  void _init() {
    // キー作成
    borderKey = GlobalKey();

    // コントローラー作成
    scrollController = ScrollController();
    scrollController.addListener(_onScrolled);
  }

  @override
  void dispose() {
    // コントローラー破棄
    scrollController.dispose();

    super.dispose();
  }

  /// 画面スクロール時の処理
  void _onScrolled() {
    // ボーダーの位置取得
    final border = borderKey.currentContext?.findRenderObject();
    if (border == null) return;
    final offset = (border as RenderBox).localToGlobal(Offset.zero);
    final topLimit = kToolbarHeight + AppBar().preferredSize.height;

    // ヘッダー開閉フラグの切り替え
    if (offset.dy < topLimit) {
      if (!headerCollapsed) {
        headerCollapsed = true;
        try {
          notifyListeners();
        } catch (_) {}
      }
    }
    if (offset.dy > topLimit) {
      if (headerCollapsed) {
        headerCollapsed = false;
        try {
          notifyListeners();
        } catch (_) {}
      }
    }
  }

  /// ノートを編集する
  void edit(BuildContext context, NoteType note) async {
    // ノート編集画面に移動する
    final edited = await toEditNote(context, note);
    if (!edited) return;

    // 編集されたならノートの情報を取得する
    loading = true;
    try {
      notifyListeners();
    } catch (_) {}

    final newNote = await getNote(note.id!);
    if (newNote != null) this.note = newNote;

    loading = false;
    try {
      notifyListeners();
    } catch (_) {}
  }

  /// ノートを削除する
  void delete(BuildContext context) async {
    // ノート削除ダイアログを表示する
    final ok = await showDeleteNoteDialog(context);
    if (!ok) return;

    // ノートを削除する
    final success = await deleteNote(note.id!);
    if (!success) return;

    Navigator.pop(context);
  }

  /// Providerを取得する
  static Widget provider(
    Widget Function(
      NoteType,
      bool,
      GlobalKey,
      ScrollController,
      void Function(NoteType),
      VoidCallback,
      bool,
    )
        builder,
    NoteType note,
  ) {
    return ChangeNotifierProvider(
      create: (context) => NoteDetailModel(note: note),
      builder: (context, _) {
        final model = context.watch<NoteDetailModel>();
        return WillPopScope(
          child: builder(
            model.note,
            model.headerCollapsed,
            model.borderKey,
            model.scrollController,
            (note) => context.read<NoteDetailModel>().edit(context, note),
            () => context.read<NoteDetailModel>().delete(context),
            model.loading,
          ),
          onWillPop: () async {
            Navigator.pop(context, model.note);
            return true;
          },
        );
      },
    );
  }
}
