import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/note/NoteDetailModel.dart';

/// ノートのFAB
class NoteFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () =>
          context.read<NoteDetailModel>().createOrUpdateMemo(null, context),
      child: const Icon(Icons.post_add),
    );
  }
}
