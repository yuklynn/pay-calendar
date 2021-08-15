import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../actions/home/navigation.dart';
import '../../actions/memo/isar_wrapper.dart';
import '../../actions/memo/navigation.dart';
import '../../actions/notes/isar_wrapper.dart';
import '../../types/MemoType.dart';
import '../../types/NoteType.dart';

/// ホーム画面のModel
class HomeModel with ChangeNotifier {
  List<NoteType> pinnedNotes = []; // ピン留めされたノートのリスト
  NoteType? shownNote; // 表示中のノート
  List<MemoType> memos = []; // メモのリスト

  /// コンストラクタ
  HomeModel() {
    // 初期処理
    _init();
  }

  /// 初期処理
  void _init() async {
    // ピン留めされたノートを取得
    final pinnedNotes = await getPinnedNoteList();
    if (pinnedNotes == null) return;
    this.pinnedNotes = pinnedNotes;

    // 最後に表示したノートを取得
    final lastShownNote = await getLastShownNote();
    shownNote =
        lastShownNote ?? (pinnedNotes.isNotEmpty ? pinnedNotes.first : null);

    // メモを取得
    if (shownNote != null) {
      final memos = await getMemoList(shownNote!.id!);
      if (memos != null) this.memos = memos;
    }

    try {
      notifyListeners();
    } catch (_) {}
  }

  /// ピン留めされたノートをタップしたときの処理
  void onTapPinnedNote(NoteType note) async {
    // 最後に表示したノートを保存
    await updateLastShownNote(note);

    // 保存結果によらず値変更
    shownNote = note;

    // メモを取得
    final memos = await getMemoList(note.id.toString());
    if (memos != null) this.memos = memos;

    try {
      notifyListeners();
    } catch (_) {}
  }

  /// メモを作成する
  void createMemo(BuildContext context) async {
    // 表示中のノートがないなら何もしない
    if (shownNote == null) return;

    // メモ作成画面に移動
    final newMemo = await toCreateMemo(context);
    if (newMemo == null) return;

    // メモを作成
    final result = await createOrUpdateMemo(newMemo, shownNote!.id.toString());
    if (result == null) return;

    // リストにメモを追加
    memos.add(result);

    try {
      notifyListeners();
    } catch (_) {}
  }

  /// カレンダー機能に移動する
  void toCalendarFunc(BuildContext context) {
    toCalendar(context);
  }

  /// ノート機能に移動する
  void toNote(BuildContext context) async {
    // ノート画面に移動
    await toNotes(context);

    // 戻るときにピン止めされたノートを取得する
    final pinnedNotes = await getPinnedNoteList();
    if (pinnedNotes == null) return;
    this.pinnedNotes = pinnedNotes;

    try {
      notifyListeners();
    } catch (_) {}
  }

  /// Providerを取得する
  static Widget provider(
    Widget Function(
      List<NoteType> pinnedNotes,
      NoteType? shownNote,
      List<MemoType> memos,
      void Function(NoteType) onTapPinnedNote,
      void Function() toCreateMemoPage,
      VoidCallback toCalendar,
      VoidCallback toNotes,
    )
        builder,
  ) {
    return ChangeNotifierProvider(
      create: (context) => HomeModel(),
      builder: (context, _) {
        final model = context.watch<HomeModel>();
        return builder(
          model.pinnedNotes,
          model.shownNote,
          model.memos,
          (note) => context.read<HomeModel>().onTapPinnedNote(note),
          () => context.read<HomeModel>().createMemo(context),
          () => context.read<HomeModel>().toCalendarFunc(context),
          () => context.read<HomeModel>().toNote(context),
        );
      },
    );
  }
}
