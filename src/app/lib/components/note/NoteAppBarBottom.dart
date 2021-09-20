import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/note/NoteDetailModel.dart';
import '../../types/MemoType.dart';
import '../../util/functions.dart';

/// ノートのAppBar下部
class NoteAppBarBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // todo: NoteModelに名前を変える
    final data = context.select<NoteDetailModel, NoteAppBarBottomData>(
      (model) => NoteAppBarBottomData(
        title: model.note?.title ?? '',
        description: model.note?.description ?? '',
        memoList: model.memoList,
        shownMemoStatus: model.shownMemoStatus,
        switchShownMemoStatus: model.switchShownMemoStatus,
        editNote: () => model.edit(context),
        deleteNote: () => model.delete(context),
      ),
    );
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitle(
            data.title,
            data.shownMemoStatus,
            data.switchShownMemoStatus,
            data.editNote,
            data.deleteNote,
            theme,
          ),
          if (data.description.isNotEmpty) ...[
            const SizedBox(height: 8.0),
            Align(
              alignment: Alignment.centerLeft,
              child: _buildDescription(
                data.description,
                theme.textTheme,
              ),
            ),
          ],
          Align(
            alignment: Alignment.centerRight,
            child: _buildTotalPayment(
              data.memoList,
              theme.textTheme,
            ),
          ),
        ],
      ),
    );
  }

  /// タイトルをビルドする
  Widget _buildTitle(
    String title,
    bool shownMemoStatus,
    void Function(bool) switchShownMemoStatus,
    VoidCallback editNote,
    VoidCallback deleteNote,
    ThemeData theme,
  ) {
    return ListTile(
      title: Text(
        title,
        style: theme.textTheme.headline6,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMemoStatusButton(
            shownMemoStatus,
            switchShownMemoStatus,
            theme,
          ),
          const SizedBox(width: 10.0),
          _buildPopupMenu(
            editNote,
            deleteNote,
          ),
        ],
      ),
    );
  }

  /// メモのステータス切り替えボタンをビルドする
  Widget _buildMemoStatusButton(
    bool shownMemoStatus,
    void Function(bool) switchShownMemoStatus,
    ThemeData theme,
  ) {
    final color = theme.primaryColor;
    return DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.only(left: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: DropdownButton<bool>(
          value: shownMemoStatus,
          onChanged: (value) {
            if (value == null) return;
            switchShownMemoStatus(value);
          },
          items: [
            DropdownMenuItem(
              child: Text('UNDONE', style: TextStyle(color: color)),
              value: false,
            ),
            DropdownMenuItem(
              child: Text('DONE', style: TextStyle(color: color)),
              value: true,
            ),
          ],
          iconEnabledColor: color,
        ),
      ),
    );
  }

  /// 説明をビルドする
  Widget _buildDescription(
    String description,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        description,
        style: textTheme.subtitle2!.copyWith(color: Colors.grey),
      ),
    );
  }

  /// 合計金額をビルドする
  Widget _buildTotalPayment(
    List<MemoType> memoList,
    TextTheme textTheme,
  ) {
    var sum = 0;
    for (var memoList in memoList) {
      sum += memoList.cost ?? 0;
    }

    final style = textTheme.subtitle1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('¥', style: style),
          const SizedBox(width: 1.5),
          Text(formatNumber(sum), style: style),
        ],
      ),
    );
  }

  /// ポップアップメニューをビルドする
  Widget _buildPopupMenu(
    VoidCallback editNote,
    VoidCallback deleteNote,
  ) {
    return PopupMenuButton<VoidCallback>(
      onSelected: (callback) => callback(),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: editNote,
          child: const Text('Edit'),
        ),
        PopupMenuItem(
          value: deleteNote,
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

class NoteAppBarBottomData {
  /// タイトル
  final String title;

  /// 説明
  final String description;

  /// メモのリスト
  final List<MemoType> memoList;

  /// 表示中のメモのステータス
  final bool shownMemoStatus;

  /// 表示中のメモステータスを変更する
  final void Function(bool) switchShownMemoStatus;

  /// ノートを編集する
  VoidCallback editNote;

  /// ノートを削除する
  VoidCallback deleteNote;

  NoteAppBarBottomData({
    required this.title,
    required this.description,
    required this.memoList,
    required this.shownMemoStatus,
    required this.switchShownMemoStatus,
    required this.editNote,
    required this.deleteNote,
  });
}
