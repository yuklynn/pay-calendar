import 'package:flutter/material.dart';

import '../../components/memo/CreateMemo.dart';
import '../../components/memo/DeleteMemoDialog.dart';
import '../../types/MemoType.dart';
import '../../util/navigation_routes.dart';

Future<MemoType?> toCreateMemo(BuildContext context) async {
  return await Navigator.push<MemoType>(
    context,
    NavigationRoute.dialog(page: CreateMemo()),
  );
}

Future<bool> showDeleteMemoDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => DeleteMemoDialog(),
  );

  return result ?? false;
}
