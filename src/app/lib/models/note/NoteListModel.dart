import 'package:flutter/material.dart';

import '../../actions/note/isar_wrapper.dart';
import '../../actions/note/navigation.dart';
import '../../types/NoteType.dart';

/// ノート一覧画面のModel
class NoteListModel with ChangeNotifier {
  List<NoteType> noteList = []; // ノートのリスト

  /// コンストラクタ
  NoteListModel() {
    // 初期処理
    _init();
  }

  /// 初期処理
  void _init() async {
    // ノートのリストを取得
    final notes = await getNoteList();
    if (notes != null) noteList = notes;
    try {
      notifyListeners();
    } catch (_) {}
  }

  /// ノートを作成する
  void createNote(BuildContext context) async {
    // ノート作成画面に移動
    final newNote = await showCreateNoteBottomSheet(context);
    if (newNote == null) return;

    // 未ロードの状態でリストに追加
    noteList.add(newNote);
    try {
      notifyListeners();
    } catch (_) {}

    // ノートを保存
    final result = await createOrUpdateNote(newNote);

    // 追加したものを置換
    if (result != null) noteList.last = result;
    try {
      notifyListeners();
    } catch (_) {}
  }

  // ノートのピン留め状態を更新する
  void updatePin(NoteType note) async {
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
}
