import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/home/HomeModel.dart';
import '../../types/NoteType.dart';
import '../common/DisableScrollGlow.dart';

/// ホームのドロワー
class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = context.select<HomeModel, HomeDrawerData>(
      (model) => HomeDrawerData(
        pinnedNoteList: model.pinnedNoteList,
        shownNote: model.shownNote,
        onTapPinnedNote: model.onTapPinnedNote,
        toCalendarPage: () => model.toCalendarPage(context),
        toNotePage: () => model.toNotePage(context),
      ),
    );

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
                    ..._buildPinnedNotes(
                      context,
                      data.pinnedNoteList,
                      data.shownNote,
                      data.onTapPinnedNote,
                    ),
                    const Divider(),

                    // 機能メニュー
                    _buildCalendar(context, data.toCalendarPage),
                    _buildNotes(context, data.toNotePage),
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

  /// todo: ドロワーヘッダーをつくる
  Widget _buildDrawerHeader() {
    return UserAccountsDrawerHeader(
      margin: const EdgeInsets.only(bottom: 0.0),
      accountEmail: const SizedBox(),
      accountName: const SizedBox(),
    );
  }

  /// ドロワー内共通のアイコンをつくる
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
  List<Widget> _buildPinnedNotes(
    BuildContext context,
    List<NoteType> pinnedNoteList,
    NoteType? shownNote,
    void Function(NoteType) onTapPinnedNote,
  ) {
    final list = <Widget>[];

    for (var note in pinnedNoteList) {
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
  Widget _buildCalendar(
    BuildContext context,
    VoidCallback toCalendarPage,
  ) {
    return ListTile(
      leading: _buildIcon(
        icon: const Icon(Icons.calendar_today),
      ),
      title: Text('Calendar'),
      onTap: () {
        Navigator.pop(context);
        toCalendarPage();
      },
    );
  }

  /// todo: ノートメニュー
  Widget _buildNotes(BuildContext context, VoidCallback toNotePage) {
    return ListTile(
      leading: _buildIcon(
        icon: const Icon(Icons.sticky_note_2),
      ),
      title: Text('Notes'),
      onTap: () {
        Navigator.pop(context);
        toNotePage();
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
}

class HomeDrawerData {
  /// ピン留めされたノートのリスト
  final List<NoteType> pinnedNoteList;

  /// 表示中のノート
  final NoteType? shownNote;

  /// ピン留めノートタップ時の処理
  final void Function(NoteType) onTapPinnedNote;

  /// カレンダー画面に移動する
  final VoidCallback toCalendarPage;

  /// ノート画面に移動する
  final VoidCallback toNotePage;

  HomeDrawerData({
    required this.pinnedNoteList,
    required this.shownNote,
    required this.onTapPinnedNote,
    required this.toCalendarPage,
    required this.toNotePage,
  });
}
