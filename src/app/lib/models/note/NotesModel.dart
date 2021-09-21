import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../actions/note/isar_wrapper.dart';
import '../../actions/note/navigation.dart';
import '../../types/NoteType.dart';

/// ノート一覧画面のModel
class NotesModel with ChangeNotifier {
  List<NoteType> noteList = []; // ノートのリスト
  bool loading = false; // ロード中か

  /// コンストラクタ
  NotesModel() {
    // 初期処理
    _init();
  }

  /// 初期処理
  void _init() async {
    loading = true;
    try {
      notifyListeners();
    } catch (_) {}

    // ノートのリストを取得
    final notes = await getNoteList();
    if (notes != null) noteList = notes;
    loading = false;
    try {
      notifyListeners();
    } catch (_) {}
  }

  /// ノートを作成する
  void createNote(BuildContext context) async {
    // ノート作成画面に移動
    final newNote = await showCreateNoteBottomSheet(context);
    if (newNote == null) return;

    loading = true;
    // 未ロードの状態でリストに追加
    noteList.add(newNote);
    try {
      notifyListeners();
    } catch (_) {}

    // ノートを保存
    final result = await createOrUpdateNote(newNote);
    loading = false;

    // 追加したものを置換
    if (result != null) noteList.last = result;
    try {
      notifyListeners();
    } catch (_) {}
  }

  // ノートのピン留め状態を更新する
  void updatePin(NoteType note) async {
    loading = true;
    try {
      notifyListeners();
    } catch (_) {}

    // ピン留めを更新
    final newNote = note.edit(pin: !note.pin);
    final result = await createOrUpdateNote(newNote);

    // リストを置換
    if (result != null) {
      final index = noteList.indexWhere((element) => element.id == result.id);
      if (index >= 0) noteList[index] = result;
    }
    loading = false;
    try {
      notifyListeners();
    } catch (_) {}
  }

  /// 詳細画面に移動する
  void toDetail(BuildContext context, NoteType note) async {
    // 詳細画面に移動する
    final res = await toNoteDetail(context, note);

    // 削除したならリストから削除
    // todo: アクション
    if (res == null) {
      noteList.remove(note);
    }
    // それ以外ならリストを置換
    else {
      final index = noteList.indexWhere((element) => element.id == res.id);
      if (index < 0) return;

      noteList[index] = res;
    }

    try {
      notifyListeners();
    } catch (_) {}
  }

  /// Providerを取得する
  static Widget provider(
    Widget Function(
      bool loading,
      List<NoteType> notes,
      VoidCallback createNote,
      void Function(NoteType) updatePin,
      void Function(NoteType) toDetail,
    )
        builder,
  ) {
    return ChangeNotifierProvider(
      create: (_) => NotesModel(),
      builder: (context, _) {
        final model = context.watch<NotesModel>();
        return builder(
          model.loading,
          model.noteList,
          () => context.read<NotesModel>().createNote(context),
          (note) => context.read<NotesModel>().updatePin(note),
          (note) => context.read<NotesModel>().toDetail(context, note),
        );
      },
    );
  }
}
