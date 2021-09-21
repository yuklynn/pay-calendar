import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/note/NotesModel.dart';
import '../../types/NoteType.dart';
import '../../util/theme.dart';
import '../common/DisableScrollGlow.dart';
import '../common/ListBottomIndicator.dart';

/// ノート一覧のbody
class NoteListBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = context.select<NotesModel, NoteListBodyData>(
      (model) => NoteListBodyData(
        noteList: model.noteList,
        updatePin: model.updatePin,
        toDetail: (note) => model.toDetail(context, note),
      ),
    );

    return DisableScrollGlow(
      child: ListView.separated(
        itemCount: data.noteList.length + 1,
        itemBuilder: (context, index) {
          if (index == data.noteList.length) return const ListBottomIndicator();

          return _buildListTile(
            data.noteList[index],
            data.updatePin,
            data.toDetail,
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }

  /// リスト1件をビルドする
  Widget _buildListTile(
    NoteType note,
    void Function(NoteType) updatePin,
    void Function(NoteType) toDetail,
  ) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.sticky_note_2),
        backgroundColor: Color(note.color),
        foregroundColor: Colors.white,
      ),
      title: Text(note.title),
      trailing: IconButton(
        icon: const Icon(Icons.push_pin),
        color: note.pin ? MainTheme.primaryColor : null,
        onPressed: () => updatePin(note),
      ),
      onTap: () => toDetail(note),
    );
  }
}

class NoteListBodyData {
  final List<NoteType> noteList;
  final void Function(NoteType) updatePin;
  final void Function(NoteType) toDetail;

  NoteListBodyData({
    required this.noteList,
    required this.updatePin,
    required this.toDetail,
  });
}
