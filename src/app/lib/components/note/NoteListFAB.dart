import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/note/NoteListModel.dart';

/// ノート一覧のFAB
class NoteListFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => context.read<NoteListModel>().createNote(context),
      child: const Icon(Icons.note_add),
    );
  }
}
