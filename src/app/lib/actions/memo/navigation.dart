import 'package:flutter/material.dart';

import '../../components/note/CreateMemo.dart';
import '../../components/note/DeleteMemoDialog.dart';
import '../../types/MemoType.dart';
import '../../util/navigation_routes.dart';

/// メモ作成画面に移動する
Future<MemoType?> toCreateMemo(MemoType? memo, BuildContext context) async {
  return await Navigator.push<MemoType>(
    context,
    NavigationRoute.dialog(page: CreateMemo(memo: memo)),
  );
}

/// メモ削除ダイアログを表示する
Future<bool> showDeleteMemoDialog(String title, BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => DeleteMemoDialog(title: title),
  );

  return result ?? false;
}
