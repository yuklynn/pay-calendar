import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/home/HomeModel.dart';
import '../components/common/DisableScrollGlow.dart';
import '../components/home/HomeDrawer.dart';
import '../components/note/NoteAppBar.dart';
import '../components/note/NoteAppBarBottom.dart';
import '../components/note/NoteBody.dart';
import '../components/note/NoteFAB.dart';
import '../models/note/NoteAppBarModel.dart';
import '../models/note/NoteDetailModel.dart';

/// ホーム画面
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeModel()),
        ChangeNotifierProvider(create: (_) => NoteAppBarModel()),
      ],
      builder: (context, _) {
        final scrollData = context.select<NoteAppBarModel, ScrollData>(
          (model) => ScrollData(
            scrollKey: model.scrollKey,
            scrollController: model.scrollController,
          ),
        );
        return ChangeNotifierProxyProvider<HomeModel, NoteDetailModel>(
          create: (_) => NoteDetailModel(),
          update: (_, home, prev) => prev!..setNote(home.shownNote!),
          builder: (context, _) {
            return Scaffold(
              drawer: HomeDrawer(),
              body: DisableScrollGlow(
                child: NestedScrollView(
                  controller: scrollData.scrollController,
                  headerSliverBuilder: (context, __) => [
                    NoteAppBar(),
                    // todo: ローディング表示
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
