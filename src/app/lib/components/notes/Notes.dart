import 'package:flutter/material.dart';

import '../../models/notes/NotesModel.dart';
import '../../types/NoteType.dart';
import '../../util/theme.dart';
import '../common/CommonAppBar.dart';
import '../common/DisableScrollGlow.dart';
import '../common/ListBottomIndicator.dart';

/// ノート一覧の表示Widget
class Notes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NotesModel.provider(
      (
        loading,
        notes,
        createNote,
        updatePin,
        toDetail,
      ) =>
          _Notes(
        loading: loading,
        notes: notes,
        createNote: createNote,
        updatePin: updatePin,
        toDetail: toDetail,
      ),
    );
  }
}

class _Notes extends StatelessWidget {
  final bool loading; // ロード中か
  final List<NoteType> notes; // ノートのリスト
  final VoidCallback createNote; // ノート作成処理
  final void Function(NoteType) updatePin; // ピン留め更新処理
  final void Function(NoteType) toDetail; // ノート詳細画面に移動する処理

  _Notes({
    required this.loading,
    required this.notes,
    required this.createNote,
    required this.updatePin,
    required this.toDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFAB(),
    );
  }

  /// AppBarをビルドする
  AppBar _buildAppBar() {
    return CommonAppBar(
      title: const Text('Notes'),
    );
  }

  /// body部をビルドする
  Widget _buildBody() {
    return Column(
      children: [
        LinearProgressIndicator(
          value: !loading ? 0.0 : null,
          backgroundColor: !loading ? Colors.transparent : null,
        ),
        Expanded(
          child: _buildList(),
        ),
      ],
    );
  }

  /// リスト部をビルドする
  Widget _buildList() {
    return DisableScrollGlow(
      child: ListView.separated(
        itemCount: notes.length + 1,
        itemBuilder: (context, index) {
          if (index == notes.length) return const ListBottomIndicator();

          return _buildListTile(notes[index], context);
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }

  /// リスト1件をビルドする
  Widget _buildListTile(NoteType note, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.sticky_note_2),
        backgroundColor: Color(note.color),
        foregroundColor: Colors.white,
      ),
      title: Text(
        note.title,
        style: TextStyle(
          color: note.id == null ? Theme.of(context).highlightColor : null,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.push_pin),
        color: note.pin ? MainTheme.primaryColor : null,
        onPressed: () => updatePin(note),
      ),
      onTap: () => toDetail(note),
    );
  }

  /// FABをビルドする
  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: createNote,
      child: const Icon(Icons.note_add),
    );
  }
}
