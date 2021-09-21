import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../models/note/NoteDetailModel.dart';
import '../../types/MemoType.dart';
import 'NoteBodyCard.dart';

/// ノートのBody
class NoteBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // todo: NoteModelに名前を変更
    final data = context.select<NoteDetailModel, NoteBodyData>(
      (model) => NoteBodyData(
        memoList: model.memoList,
        createOrUpdateMemo: (memo) => model.createOrUpdateMemo(memo, context),
        updateMemoStatus: model.updateMemoStatus,
        deleteMemo: (memo) => model.deleteMemo(memo, context),
      ),
    );

    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      itemCount: data.memoList.length,
      itemBuilder: (context, index) => NoteBodyCard(
        memo: data.memoList[index],
        edit: data.createOrUpdateMemo,
        updateStatus: data.updateMemoStatus,
        delete: data.deleteMemo,
      ),
      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      padding: EdgeInsets.only(
        top: 8.0,
        bottom: 100.0,
      ),
    );
  }
}

class NoteBodyData {
  final List<MemoType> memoList;
  final void Function(MemoType?) createOrUpdateMemo;
  final void Function(MemoType, bool) updateMemoStatus;
  final void Function(MemoType) deleteMemo;

  NoteBodyData({
    required this.memoList,
    required this.createOrUpdateMemo,
    required this.updateMemoStatus,
    required this.deleteMemo,
  });
}
