import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/note/NoteAppBarModel.dart';
import '../../models/note/NoteModel.dart';
import '../../util/colors.dart';

/// ノートのAppBar
class NoteAppBar extends StatelessWidget {
  static const height = 200.0;

  @override
  Widget build(BuildContext context) {
    final noteData = context.select<NoteModel, NoteData>(
      (model) => NoteData(
        title: model.note?.title ?? '',
        color: model.note?.color ?? defaultColor,
      ),
    );

    final appBarData = context.select<NoteAppBarModel, NoteAppBarData>(
      (model) => NoteAppBarData(
        collapsed: model.collapsed,
      ),
    );

    return SliverAppBar(
      backgroundColor: Color(noteData.color),
      iconTheme: IconThemeData(color: Colors.white),
      pinned: true,
      title: appBarData.collapsed
          ? Text(
              noteData.title,
              style: TextStyle(color: Colors.white),
            )
          : null,
      expandedHeight: height,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          height: height,
          color: Color(noteData.color),
        ),
      ),
    );
  }
}

class NoteData {
  final String title;
  final int color;

  NoteData({
    required this.title,
    required this.color,
  });
}

class NoteAppBarData {
  final bool collapsed;
  NoteAppBarData({
    required this.collapsed,
  });
}
