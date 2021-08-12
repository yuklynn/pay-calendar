import 'package:flutter/material.dart';

import '../../models/notes/NoteDetailModel.dart';
import '../../types/NoteType.dart';
import '../common/DisableScrollGlow.dart';
import '../common/ListBottomIndicator.dart';

/// ノート詳細画面
class NoteDetail extends StatelessWidget {
  final NoteType note;

  NoteDetail({
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return NoteDetailModel.provider(
      (
        listenNote,
        headerCollapsed,
        borderKey,
        scrollController,
        toEdit,
        delete,
        loading,
      ) =>
          _NoteDetail(
        note: listenNote,
        headerCollapsed: headerCollapsed,
        borderKey: borderKey,
        scrollController: scrollController,
        toEdit: toEdit,
        delete: delete,
        loading: loading,
      ),
      note,
    );
  }
}

class _NoteDetail extends StatelessWidget {
  final NoteType note;
  final bool headerCollapsed;
  final GlobalKey borderKey;
  final ScrollController scrollController;
  final void Function(NoteType) toEdit;
  final VoidCallback delete;
  final bool loading;

  _NoteDetail({
    required this.note,
    required this.headerCollapsed,
    required this.borderKey,
    required this.scrollController,
    required this.toEdit,
    required this.delete,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DisableScrollGlow(
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            // ヘッダー
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: LinearProgressIndicator(
                value: !loading ? 0.0 : null,
                backgroundColor: !loading ? Colors.transparent : null,
              ),
            ),
            _buildAppBarBottom(context),
            SliverToBoxAdapter(
              child: Divider(key: borderKey),
            ),

            // body
            _buildBody(),
          ],
        ),
      ),
    );
  }

  /// ヘッダー
  Widget _buildAppBar(BuildContext context) {
    const height = 200.0;
    return SliverAppBar(
      backgroundColor: Color(note.color),
      iconTheme: IconThemeData(color: Colors.white),
      pinned: true,
      title: headerCollapsed
          ? Text(
              note.name,
              style: TextStyle(color: Colors.white),
            )
          : null,
      expandedHeight: height,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          height: height,
          color: Color(note.color),
        ),
      ),
      actions: [
        IconButton(
          onPressed: delete,
          icon: const Icon(Icons.delete),
        )
      ],
    );
  }

  /// ヘッダー下のタイトル部分
  Widget _buildAppBarBottom(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              note.name,
              style: Theme.of(context).textTheme.headline6,
            ),
            trailing: OutlinedButton(
              onPressed: () => toEdit(note),
              child: Text('Edit'), // todo:
            ),
          ),
          if (note.description?.isNotEmpty ?? false)
            ListTile(
              title: Text(
                note.description!,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final list = <Widget>[];
    for (var i in List.filled(20, null)) {
      list.add(
        ListTile(
          title: Text('test_$i'),
        ),
      );
      list.add(const Divider());
    }
    list.add(const ListBottomIndicator());
    return SliverList(delegate: SliverChildListDelegate(list));
  }
}
