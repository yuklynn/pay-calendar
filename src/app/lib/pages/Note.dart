import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/common/DisableScrollGlow.dart';
import '../components/note/NoteAppBar.dart';
import '../components/note/NoteAppBarBottom.dart';
import '../components/note/NoteBody.dart';
import '../components/note/NoteFAB.dart';
import '../models/note/NoteAppBarModel.dart';
import '../models/note/NoteModel.dart';
import '../types/NoteType.dart';

/// ノート画面
class Note extends StatelessWidget {
  final NoteType note;

  Note({
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteModel(note: note)),
        ChangeNotifierProvider(create: (_) => NoteAppBarModel()),
      ],
      builder: (context, _) {
        final scrollData = context.select<NoteAppBarModel, ScrollData>(
          (model) => ScrollData(
            scrollKey: model.scrollKey,
            scrollController: model.scrollController,
          ),
        );
        return Scaffold(
          body: DisableScrollGlow(
            child: NestedScrollView(
              controller: scrollData.scrollController,
              headerSliverBuilder: (context, __) => [
                NoteAppBar(),
                SliverToBoxAdapter(
                  child: const SizedBox(height: 8.0),
                ),
                NoteAppBarBottom(),
                SliverToBoxAdapter(
                  child: Divider(key: scrollData.scrollKey),
                ),
              ],
              body: NoteBody(),
            ),
          ),
          floatingActionButton: NoteFAB(),
        );
      },
    );
  }
}

class ScrollData {
  final GlobalKey scrollKey;
  final ScrollController scrollController;

  ScrollData({
    required this.scrollKey,
    required this.scrollController,
  });
}
