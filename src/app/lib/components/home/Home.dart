import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../models/home/HomeModel.dart';
import '../../types/MemoType.dart';
import '../../types/NoteType.dart';
import '../common/CommonAppBar.dart';
import '../common/DisableScrollGlow.dart';
import '../note/src/MemoCard.dart';

/// ホーム画面
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeModel.provider(
      (
        pinnedNotes,
        shownNote,
        memos,
        onTapPinnedNote,
        createMemo,
        toCalendar,
        toNotes,
      ) =>
          _Home(
        pinnedNotes: pinnedNotes,
        shownNote: shownNote,
        memos: memos,
        onTapPinnedNote: onTapPinnedNote,
        createMemo: createMemo,
        toCalendar: toCalendar,
        toNotes: toNotes,
      ),
    );
  }
}

class _Home extends StatelessWidget {
  final List<NoteType> pinnedNotes;
  final NoteType? shownNote;
  final List<MemoType> memos;
  final void Function(NoteType) onTapPinnedNote;
  final void Function() createMemo;
  final VoidCallback toCalendar;
  final VoidCallback toNotes;

  _Home({
    required this.pinnedNotes,
    required this.shownNote,
    required this.memos,
    required this.onTapPinnedNote,
    required this.createMemo,
    required this.toCalendar,
    required this.toNotes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(context),
      floatingActionButton: _buildFAB(),
      body: _buildBody(),
    );
  }

  /// ヘッダーを作る
  AppBar _buildAppBar() {
    return CommonAppBar();
  }

  /// ドロワーを作る
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // ドロワーヘッダー
          _buildDrawerHeader(),
          Expanded(
            child: DisableScrollGlow(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ピン留めしたノートのリスト
                    _buildPinnedTitle(context),
                    ..._buildPinnedNotes(context),
                    const Divider(),

                    // 機能メニュー
                    _buildCalendar(context),
                    _buildNotes(context),
                    _buildSettings(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ドロワーヘッダー
  Widget _buildDrawerHeader() {
    // todo:
    return UserAccountsDrawerHeader(
      margin: const EdgeInsets.only(bottom: 0.0),
      accountEmail: const SizedBox(),
      accountName: const SizedBox(),
    );
  }

  /// ドロワー内共通のアイコンを作る
  Widget _buildIcon({
    Widget? icon,
    Color? foregroundColor,
    Color? backgroundColor,
  }) {
    return CircleAvatar(
      radius: 32 / 2,
      child: icon,
      backgroundColor: backgroundColor ?? Colors.transparent,
      foregroundColor: foregroundColor ?? Colors.grey,
    );
  }

  /// ピン留めのタイトル
  Widget _buildPinnedTitle(BuildContext context) {
    return Container(
      width: BoxConstraints.expand().maxWidth,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        'Pinned',
        style: Theme.of(context).textTheme.subtitle2,
      ),
      color: Theme.of(context).highlightColor,
    );
  }

  /// ピン留めしたノートのリスト
  List<Widget> _buildPinnedNotes(BuildContext context) {
    final list = <Widget>[];

    for (var note in pinnedNotes) {
      list.add(
        ListTile(
          leading: _buildIcon(
            icon: const Icon(Icons.sticky_note_2),
            foregroundColor: Colors.white,
            backgroundColor: Color(note.color),
          ),
          title: Text(
            note.title,
            style: TextStyle(
              // 表示中なら太字
              fontWeight:
                  note.id == (shownNote?.id ?? '') ? FontWeight.bold : null,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            onTapPinnedNote(note);
          },
        ),
      );
    }

    return list;
  }

  /// todo: カレンダーメニュー
  Widget _buildCalendar(BuildContext context) {
    return ListTile(
      leading: _buildIcon(
        icon: const Icon(Icons.calendar_today),
      ),
      title: Text('Calendar'),
      onTap: () {
        Navigator.pop(context);
        toCalendar();
      },
    );
  }

  /// todo: ノートメニュー
  Widget _buildNotes(BuildContext context) {
    return ListTile(
      leading: _buildIcon(
        icon: const Icon(Icons.sticky_note_2),
      ),
      title: Text('Notes'),
      onTap: () {
        Navigator.pop(context);
        toNotes();
      },
    );
  }

  /// todo: 設定メニュー
  Widget _buildSettings() {
    return ListTile(
      leading: _buildIcon(
        icon: const Icon(Icons.settings),
      ),
      title: Text('Settings'),
      onTap: () {},
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: createMemo,
      child: const Icon(Icons.add),
    );
  }

  /// bodyをつくる
  Widget _buildBody() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      itemCount: memos.length,
      itemBuilder: (context, index) => MemoCard(
        memo: memos[index],
        edit: (_) {},
        done: (_) {},
        delete: (_) {},
      ),
      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      padding: EdgeInsets.only(bottom: 100.0),
    );
  }
}
