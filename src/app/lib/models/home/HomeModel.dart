import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../actions/home/navigation.dart';
import '../../actions/memo/navigation.dart';
import '../../isar/controllers/controller.dart';
import '../../isar/controllers/controller.dart';
import '../../types/MemoType.dart';
import '../../types/NoteType.dart';

class HomeModel with ChangeNotifier {
  List<NoteType> pinnedNotes = [];
  NoteType? shownNote;
  List<MemoType> memos = [];

  HomeModel() {
    _init();
  }

  void _init() async {
    await _initPinnedNotes();
    _initMemos();
  }

  Future<void> _initPinnedNotes() async {
    final pinnedNotes = await _getPinnedNotes();
    final lastShownNote = await _getLastShownNote();

    this.pinnedNotes = pinnedNotes;
    shownNote =
        lastShownNote ?? (pinnedNotes.isNotEmpty ? pinnedNotes.first : null);
    try {
      notifyListeners();
    } catch (_) {}
  }

  void _initMemos() async {
    if (shownNote == null) return;

    final memos = await MemoController.getByNote(shownNote!.id!);
    this.memos = memos;
    try {
      notifyListeners();
    } catch (_) {}
  }

  Future<List<NoteType>> _getPinnedNotes() async {
    return await NoteController.getPinned();
  }

  Future<NoteType?> _getLastShownNote() async {
    return await NoteController.getLastShown();
  }

  void onTapPinnedNote(NoteType note) async {
    // 最後に表示したノートを保存
    NoteController.putLastShown(note);

    // 保存結果によらず値変更
    shownNote = note;

    try {
      notifyListeners();
    } catch (_) {}

    // メモ取得
    _initMemos();
  }

  void createMemo(BuildContext context) async {
    final newMemo = await toCreateMemo(context);
    if (newMemo == null) return;

    final result = await MemoController.put(newMemo, shownNote!.id!);
    if (result == null) return;

    memos.add(result);
    try {
      notifyListeners();
    } catch (_) {}
  }

  void toCalendarFunc(BuildContext context) {
    toCalendar(context);
  }

  void toNote(BuildContext context) async {
    await toNotes(context);
    _initPinnedNotes();
  }

  static Widget provider(
    Widget Function(
      List<NoteType> pinnedNotes,
      NoteType? shownNote,
      List<MemoType> memos,
      void Function(NoteType) onTapPinnedNote,
      void Function() toCreateMemoPage,
      VoidCallback toCalendar,
      VoidCallback toNotes,
    )
        builder,
  ) {
    return ChangeNotifierProvider(
      create: (context) => HomeModel(),
      builder: (context, _) {
        final model = context.watch<HomeModel>();
        return builder(
          model.pinnedNotes,
          model.shownNote,
          model.memos,
          (note) => context.read<HomeModel>().onTapPinnedNote(note),
          () => context.read<HomeModel>().createMemo(context),
          () => context.read<HomeModel>().toCalendarFunc(context),
          () => context.read<HomeModel>().toNote(context),
        );
      },
    );
  }
}
