import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/note/NotesModel.dart';
import '../common/CommonAppBar.dart';
import 'NoteListBody.dart';
import 'NoteListFAB.dart';

/// ノート一覧画面
class Notes extends StatelessWidget {
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
