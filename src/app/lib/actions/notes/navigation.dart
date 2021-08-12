import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/notes/CreateNoteBottomSheet.dart';
import '../../components/notes/DeleteNoteDialog.dart';
import '../../components/notes/EditNote.dart';
import '../../components/notes/NoteDetail.dart';
import '../../types/NoteType.dart';
import '../../util/navigation_routes.dart';

/// ノート作成ボトムシートを表示
Future<NoteType?> showCreateNoteBottomSheet(BuildContext context) async {
  return await showModalBottomSheet<NoteType>(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    context: context,
    builder: (context) => CreateNoteBottomSheet(),
  );
}

/// ノート詳細画面に移動
Future<NoteType?> toNoteDetail(BuildContext context, NoteType note) async {
  // 画面POP時のノートの情報を受け取る
  return await Navigator.push<NoteType>(
    context,
    NavigationRoute.forward(
      page: NoteDetail(note: note),
    ),
  );
}

/// ノート削除ダイアログを表示
Future<bool> showDeleteNoteDialog(BuildContext context) async {
  final res = await showDialog<bool>(
    context: context,
    builder: (context) => DeleteNoteDialog(),
  );

  return res ?? false;
}

/// ノート編集画面を表示
Future<bool> toEditNote(BuildContext context, NoteType note) async {
  // 編集したかどうかを受け取る
  final edited = await Navigator.push(
    context,
    NavigationRoute.forward(
      page: EditNote(note: note),
    ),
  );

  return edited;
}
