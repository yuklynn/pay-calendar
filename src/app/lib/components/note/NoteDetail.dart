import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../models/note/NoteDetailModel.dart';
import '../../types/MemoType.dart';
import '../../types/NoteType.dart';
import '../../util/functions.dart';
import '../common/DisableScrollGlow.dart';
import 'src/MemoCard.dart';

/// ノート詳細画面
class NoteDetail extends StatelessWidget {
  final NoteType note;

  NoteDetail({
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return NoteDetailModel.provider(
      (
        note,
        memos,
        headerCollapsed,
        borderKey,
        scrollController,
        edit,
        delete,
        loading,
        createOrUpdateMemo,
        updateMemoStatus,
        deleteMemo,
        shownMemoStatus,
        switchShownMemoStatus,
      ) =>
          _NoteDetail(
        note: note,
        memos: memos,
        headerCollapsed: headerCollapsed,
        borderKey: borderKey,
        scrollController: scrollController,
        edit: edit,
        delete: delete,
        loading: loading,
        createOrUpdateMemo: createOrUpdateMemo,
        updateMemoStatus: updateMemoStatus,
        deleteMemo: deleteMemo,
        shownMemoStatus: shownMemoStatus,
        switchShownMemoStatus: switchShownMemoStatus,
      ),
      note,
    );
  }
}

class _NoteDetail extends StatelessWidget {
  final NoteType note; // ノートの情報
  final List<MemoType> memos; // メモのリスト
  final bool headerCollapsed; // ヘッダーが閉じているか
  final GlobalKey borderKey; // ボーダーのKey
  final ScrollController scrollController; // スクロールのコントローラー
  final VoidCallback edit; // ノート編集処理
  final VoidCallback delete; // ノート削除処理
  final bool loading; // ロード中か

  final void Function(MemoType?) createOrUpdateMemo; // メモを作成・編集する
  final void Function(MemoType, bool) updateMemoStatus; // メモのステータスを変更する
  final void Function(MemoType) deleteMemo; // メモを削除する
  final bool shownMemoStatus; // 表示中のメモのステータス
  final void Function(bool) switchShownMemoStatus; // 表示するメモのステータスを変更する

  _NoteDetail({
    required this.note,
    required this.memos,
    required this.headerCollapsed,
    required this.borderKey,
    required this.scrollController,
    required this.edit,
    required this.delete,
    required this.loading,
    required this.createOrUpdateMemo,
    required this.updateMemoStatus,
    required this.deleteMemo,
    required this.shownMemoStatus,
    required this.switchShownMemoStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DisableScrollGlow(
        child: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (context, __) => [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: LinearProgressIndicator(
                value: !loading ? 0.0 : null,
                backgroundColor: !loading ? Colors.transparent : null,
              ),
            ),
            _buildAppBarBottom(context),
            SliverToBoxAdapter(
              child: Divider(key: borderKey),
            ),
          ],
          body: _buildBody(),
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  /// ヘッダー
  Widget _buildAppBar() {
    const height = 200.0;
    return SliverAppBar(
      backgroundColor: Color(note.color),
      iconTheme: IconThemeData(color: Colors.white),
      pinned: true,
      title: headerCollapsed
          ? Text(
              note.title,
              style: TextStyle(color: Colors.white),
            )
          : null,
      expandedHeight: height,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          height: height,
          color: Color(note.color),
        ),
      ),
    );
  }

  /// ヘッダー下のタイトル部分をビルドする
  Widget _buildAppBarBottom(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitle(theme),
          if (note.description?.isNotEmpty ?? false) ...[
            const SizedBox(height: 8.0),
            Align(
              alignment: Alignment.centerLeft,
              child: _buildDescription(theme.textTheme),
            ),
          ],
          Align(
            alignment: Alignment.centerRight,
            child: _buildTotalPayment(theme.textTheme),
          ),
        ],
      ),
    );
  }

  /// タイトルをビルドする
  Widget _buildTitle(ThemeData theme) {
    return ListTile(
      title: Text(
        note.title,
        style: theme.textTheme.headline6,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMemoStatusButton(theme),
          _buildPopupMenu(),
        ],
      ),
    );
  }

  /// メモのステータス切り替えボタンをビルドする
  Widget _buildMemoStatusButton(ThemeData theme) {
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
  Widget _buildDescription(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        note.description!,
        style: textTheme.subtitle2!.copyWith(color: Colors.grey),
      ),
    );
  }

  /// 合計金額をビルドする
  Widget _buildTotalPayment(TextTheme textTheme) {
    var sum = 0;
    for (var memo in memos) {
      sum += memo.cost ?? 0;
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
  Widget _buildPopupMenu() {
    return PopupMenuButton<VoidCallback>(
      onSelected: (callback) => callback(),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: edit,
          child: const Text('Edit'),
        ),
        PopupMenuItem(
          value: delete,
          child: const Text('Delete'),
        ),
      ],
    );
  }

  /// ボディをビルドする
  Widget _buildBody() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      itemCount: memos.length,
      itemBuilder: (context, index) => MemoCard(
        memo: memos[index],
        edit: createOrUpdateMemo,
        updateStatus: updateMemoStatus,
        delete: deleteMemo,
      ),
      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      padding: EdgeInsets.only(
        top: 8.0,
        bottom: 100.0,
      ),
    );
  }

  /// FABをビルドする
  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () => createOrUpdateMemo(null),
      child: const Icon(Icons.post_add),
    );
  }
}
