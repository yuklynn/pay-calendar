import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/note/NotesModel.dart';

/// ノート一覧のFAB
class NoteListFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => context.read<NotesModel>().createNote(context),
      child: const Icon(Icons.note_add),
    );
  }
}
