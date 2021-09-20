import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/home/HomeModel.dart';
import '../components/common/DisableScrollGlow.dart';
import '../components/home/HomeDrawer.dart';
import '../components/note/NoteAppBar.dart';
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
          update: (_, home, prev) => prev!..note = home.shownNote,
          builder: (context, _) {
            return Scaffold(
              drawer: HomeDrawer(),
              body: DisableScrollGlow(
                child: NestedScrollView(
                  controller: scrollData.scrollController,
                  headerSliverBuilder: (context, __) => [
                    NoteAppBar(),
                    SliverToBoxAdapter(
                      child: Divider(key: scrollData.scrollKey),
                    ),
                  ],
                  body: const SizedBox(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Widget _buildFAB() {
  //   return FloatingActionButton(
  //     onPressed: createMemo,
  //     child: const Icon(Icons.add),
  //   );
  // }

  // /// bodyをつくる
  // Widget _buildBody() {
  //   return StaggeredGridView.countBuilder(
  //     crossAxisCount: 2,
  //     itemCount: memos.length,
  //     itemBuilder: (context, index) => MemoCard(
  //       memo: memos[index],
  //       edit: (_) {},
  //       updateStatus: (_, __) {},
  //       delete: (_) {},
  //     ),
  //     staggeredTileBuilder: (index) => StaggeredTile.fit(1),
  //     padding: EdgeInsets.only(bottom: 100.0),
  //   );
  // }
}

class ScrollData {
  final GlobalKey scrollKey;
  final ScrollController scrollController;

  ScrollData({
    required this.scrollKey,
    required this.scrollController,
  });
}
