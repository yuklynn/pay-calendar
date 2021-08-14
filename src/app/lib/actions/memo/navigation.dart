import 'package:flutter/material.dart';

import '../../components/memo/CreateMemo.dart';
import '../../components/memo/DeleteMemoDialog.dart';
import '../../types/MemoType.dart';
import '../../util/navigation_routes.dart';

/// メモ作成画面に移動する
Future<MemoType?> toCreateMemo(BuildContext context) async {
  return await Navigator.push<MemoType>(
    context,
    NavigationRoute.dialog(page: CreateMemo()),
  );
}

/// メモ削除ダイアログを表示する
Future<bool> showDeleteMemoDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => DeleteMemoDialog(),
  );

  return result ?? false;
}
