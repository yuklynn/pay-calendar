import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../actions/notes/navigation.dart';
import '../../isar/note/controller.dart';
import '../../types/NoteType.dart';

class NoteDetailModel with ChangeNotifier {
  NoteType note;
  bool headerCollapsed = false;
  late GlobalKey borderKey;
  late ScrollController scrollController;
  bool loading = false;

  NoteDetailModel({
    required this.note,
  }) {
    _init();
  }

  void _init() {
    borderKey = GlobalKey();

    scrollController = ScrollController();
    scrollController.addListener(_onScrolled);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _onScrolled() {
    final border = borderKey.currentContext?.findRenderObject();
    if (border == null) return;

    final offset = (border as RenderBox).localToGlobal(Offset.zero);
    final topLimit = kToolbarHeight + AppBar().preferredSize.height;
    if (offset.dy < topLimit) {
      if (!headerCollapsed) {
        headerCollapsed = true;
        try {
          notifyListeners();
        } catch (_) {}
      }
    }
    if (offset.dy > topLimit) {
      if (headerCollapsed) {
        headerCollapsed = false;
        try {
          notifyListeners();
        } catch (_) {}
      }
    }
  }

  void toEdit(BuildContext context, NoteType note) async {
    final edited = await toEditNote(context, note);

    if (edited) {
      loading = true;
      try {
        notifyListeners();
      } catch (_) {}

      final newNote = await NoteController().get(int.parse(note.id!));
      if (newNote != null) this.note = newNote;

      loading = false;
      try {
        notifyListeners();
      } catch (_) {}
    }
  }

  void delete(BuildContext context) async {
    final ok = await showDeleteNoteDialog(context);
    if (!ok) return;

    final success = await NoteController().delete(int.parse(note.id!));
    if (!success) return;

    Navigator.pop(context);
  }

  static Widget provider(
    Widget Function(
      NoteType,
      bool,
      GlobalKey,
      ScrollController,
      void Function(NoteType),
      VoidCallback,
      bool,
    )
        builder,
    NoteType note,
  ) {
    return ChangeNotifierProvider(
      create: (context) => NoteDetailModel(note: note),
      builder: (context, _) {
        final model = context.watch<NoteDetailModel>();
        return WillPopScope(
          child: builder(
            model.note,
            model.headerCollapsed,
            model.borderKey,
            model.scrollController,
            (note) => context.read<NoteDetailModel>().toEdit(context, note),
            () => context.read<NoteDetailModel>().delete(context),
            model.loading,
          ),
          onWillPop: () async {
            Navigator.pop(context, model.note);
            return true;
          },
        );
      },
    );
  }
}
