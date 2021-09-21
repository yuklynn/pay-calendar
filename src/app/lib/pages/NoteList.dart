import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/common/CommonAppBar.dart';
import '../components/note/NoteListBody.dart';
import '../components/note/NoteListFAB.dart';
import '../models/note/NotesModel.dart';

/// ノート一覧画面
class NoteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotesModel()),
      ],
      builder: (context, _) {
        return Scaffold(
          appBar: CommonAppBar(
            title: const Text('Notes'),
          ),
          body: NoteListBody(),
          floatingActionButton: NoteListFAB(),
        );
      },
    );
  }
}
