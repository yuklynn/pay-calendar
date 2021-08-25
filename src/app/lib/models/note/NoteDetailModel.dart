import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../actions/memo/isar_wrapper.dart';
import '../../actions/memo/navigation.dart';
import '../../actions/note/isar_wrapper.dart';
import '../../actions/note/navigation.dart';
import '../../types/MemoType.dart';
import '../../types/NoteType.dart';

/// ノート詳細画面のModel
class NoteDetailModel with ChangeNotifier {
  NoteType note; // ノート
  List<MemoType> memos = []; // メモのリスト
  bool memoStatus = false; // 表示中のメモの完了状態
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
  void _init() async {
    // キー作成
    borderKey = GlobalKey();

    // コントローラー作成
    scrollController = ScrollController();
    scrollController.addListener(_onScrolled);

    // メモを取得
    final memos = await getMemoList(note.id!, done: memoStatus);
    if (memos == null) return;
    this.memos = memos;

    try {
      notifyListeners();
    } catch (_) {}
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
  void edit(BuildContext context) async {
    // ノート編集画面に移動する
    final edited = await toEditNote(context, note);
    if (!edited) return;

    // 編集されたならノートの情報を取得する
    loading = true;
    try {
      notifyListeners();
    } catch (_) {}

    final newNote = await getNote(note.id!);
    if (newNote != null) note = newNote;

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

  /// メモを作成・編集する
  void _createOrUpdateMemo(MemoType? memo, BuildContext context) async {
    // メモ作成画面を表示
    final newMemo = await toCreateMemo(memo, context);
    if (newMemo == null) return;

    // メモを作成
    final result = await createOrUpdateMemo(newMemo, note.id!);
    if (result == null) return;

    // メモのリストに追加
    final index = memos.indexWhere((elem) => elem.id == result.id);

    index < 0 ? memos.add(result) : memos[index] = result;
    try {
      notifyListeners();
    } catch (_) {}
  }

  /// メモのステータスを変更する
  void updateMemoStatus(MemoType memo, bool done) async {
    // メモのデータ型を完了にする
    final newMemo = memo.edit(done: done);

    // メモを更新
    final result = await createOrUpdateMemo(newMemo, note.id!);
    if (result == null) return;

    final index = memos.indexWhere((elem) => elem.id == newMemo.id);
    if (index < 0) return;

    // LikeButtonを使っているので不要
    // 一瞬だけ置換する
    // memos[index] = result;
    // try {
    //   notifyListeners();
    // } catch (_) {}

    // 少し待ってメモのリストから削除
    await Future<void>.delayed(const Duration(milliseconds: 750));
    memos.removeAt(index);
    try {
      notifyListeners();
    } catch (_) {}
  }

  /// メモを削除する
  void _deleteMemo(MemoType memo, BuildContext context) async {
    // ダイアログ表示
    final ok = await showDeleteMemoDialog(memo.title, context);
    if (!ok) return;

    // メモを削除
    final success = await deleteMemo(memo.id!);
    if (!success) return;

    // メモのリストからメモを削除
    final index = memos.indexWhere((elem) => elem.id == memo.id);
    if (index < 0) return;

    memos.removeAt(index);
    try {
      notifyListeners();
    } catch (_) {}
  }

  /// 表示メモのステータスを変更する
  void switchShownMemoStatus(bool status) async {
    // ステータスに変更なしなら何もしない
    if (memoStatus == status) return;

    // ステータス変更
    memoStatus = status;

    // メモを再取得
    final result = await getMemoList(note.id!, done: status);
    if (result == null) return;

    memos = result;
    try {
      notifyListeners();
    } catch (_) {}
  }

  /// Providerを取得する
  static Widget provider(
    Widget Function(
      NoteType,
      List<MemoType>,
      bool,
      GlobalKey,
      ScrollController,
      VoidCallback,
      VoidCallback,
      bool,
      void Function(MemoType?),
      void Function(MemoType, bool),
      void Function(MemoType),
      bool shownMemoStatus,
      void Function(bool),
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
            model.memos,
            model.headerCollapsed,
            model.borderKey,
            model.scrollController,
            () => context.read<NoteDetailModel>().edit(context),
            () => context.read<NoteDetailModel>().delete(context),
            model.loading,
            (memo) => context
                .read<NoteDetailModel>()
                ._createOrUpdateMemo(memo, context),
            (memo, done) =>
                context.read<NoteDetailModel>().updateMemoStatus(memo, done),
            (memo) =>
                context.read<NoteDetailModel>()._deleteMemo(memo, context),
            model.memoStatus,
            (status) =>
                context.read<NoteDetailModel>().switchShownMemoStatus(status),
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
