import 'package:flutter/material.dart';

import '../../actions/memo/isar_wrapper.dart';
import '../../actions/memo/navigation.dart';
import '../../actions/note/isar_wrapper.dart';
import '../../actions/note/navigation.dart';
import '../../types/MemoType.dart';
import '../../types/NoteType.dart';

/// ノートのModel
class NoteModel with ChangeNotifier {
  NoteType? note; // ノート
  List<MemoType> memoList = []; // メモのリスト
  bool shownMemoStatus = false; // 表示中のメモのステータス

  /// コンストラクタ
  NoteModel({
    this.note,
  }) {
    // 初期処理
    _init();
  }

  /// 初期処理
  void _init() async {
    // メモを取得
    if (note != null) {
      final memoList = await MemoIsarWrapper()
          .getMemoList(note?.id ?? '', done: shownMemoStatus);
      if (memoList == null) return;
      this.memoList = memoList;
    }

    try {
      notifyListeners();
    } catch (_) {}
  }

  /// 外部からノートをセットする
  void setNote(NoteType note) async {
    this.note = note;

    // メモを取得
    final memoList = await MemoIsarWrapper()
        .getMemoList(note.id ?? '', done: shownMemoStatus);
    if (memoList == null) return;
    this.memoList = memoList;

    try {
      notifyListeners();
    } catch (_) {}
  }

  /// ノートを編集する
  void edit(BuildContext context) async {
    // ノート編集画面に移動する
    final edited = await toEditNote(context, note!);
    if (!edited) return;

    // 編集されたならノートの情報を取得する
    final newNote = await getNote(note!.id!);
    if (newNote != null) note = newNote;

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
    final success = await deleteNote(note!.id!);
    if (!success) return;

    Navigator.pop(context);
  }

  /// メモを作成・編集する
  void createOrUpdateMemo(MemoType? memo, BuildContext context) async {
    // メモ作成画面を表示
    final newMemo = await toCreateMemo(memo, context);
    if (newMemo == null) return;

    // メモを作成
    final result =
        await MemoIsarWrapper().createOrUpdateMemo(newMemo, note!.id!);
    if (result == null) return;

    // メモのリストに追加
    final index = memoList.indexWhere((elem) => elem.id == result.id);

    index < 0 ? memoList.add(result) : memoList[index] = result;
    try {
      notifyListeners();
    } catch (_) {}
  }

  /// メモのステータスを変更する
  void updateMemoStatus(MemoType memo, bool done) async {
    // メモのデータ型を完了にする
    final newMemo = memo.edit(done: done);

    // メモを更新
    final result =
        await MemoIsarWrapper().createOrUpdateMemo(newMemo, note!.id!);
    if (result == null) return;

    final index = memoList.indexWhere((elem) => elem.id == newMemo.id);
    if (index < 0) return;

    // LikeButtonを使っているので不要
    // 一瞬だけ置換する
    // memoList[index] = result;
    // try {
    //   notifyListeners();
    // } catch (_) {}

    // 少し待ってメモのリストから削除
    await Future<void>.delayed(const Duration(milliseconds: 750));
    memoList.removeAt(index);
    try {
      notifyListeners();
    } catch (_) {}
  }

  /// メモを削除する
  void deleteMemo(MemoType memo, BuildContext context) async {
    // ダイアログ表示
    final ok = await showDeleteMemoDialog(memo.title, context);
    if (!ok) return;

    // メモを削除
    final success = await MemoIsarWrapper().deleteMemo(memo.id!);
    if (!success) return;

    // メモのリストからメモを削除
    final index = memoList.indexWhere((elem) => elem.id == memo.id);
    if (index < 0) return;

    memoList.removeAt(index);
    try {
      notifyListeners();
    } catch (_) {}
  }

  /// 表示メモのステータスを変更する
  void switchShownMemoStatus(bool status) async {
    // ステータスに変更なしなら何もしない
    if (shownMemoStatus == status) return;

    // ステータス変更
    shownMemoStatus = status;

    // メモを再取得
    final result = await MemoIsarWrapper().getMemoList(note!.id!, done: status);
    if (result == null) return;

    memoList = result;
    try {
      notifyListeners();
    } catch (_) {}
  }
}
