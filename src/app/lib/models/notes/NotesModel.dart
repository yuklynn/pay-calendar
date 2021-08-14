import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../actions/notes/navigation.dart';
import '../../isar/note/controller.dart';
import '../../types/NoteType.dart';

class NotesModel with ChangeNotifier {
  List<NoteType> notes = [];
  bool loading = false;

  NotesModel() {
    init();
  }

  void init() async {
    loading = true;
    try {
      notifyListeners();
    } catch (_) {}

    final initVal = await NoteController().getAll();
    notes = initVal;
    loading = false;
    try {
      notifyListeners();
    } catch (_) {}
  }

  void createNote(BuildContext context) async {
    final newNote = await showCreateNoteBottomSheet(context);
    if (newNote == null) return;

    loading = true;
    notes.add(newNote);
    try {
      notifyListeners();
    } catch (_) {}

    final result = await NoteController().createOrUpdate(newNote);
    loading = false;
    if (result != null) notes.last = result;
    try {
      notifyListeners();
    } catch (_) {}
  }

  void updatePin(NoteType note) async {
    loading = true;
    try {
      notifyListeners();
    } catch (_) {}

    final newNote = note.edit(pin: !note.pin);
    final result = await NoteController().createOrUpdate(newNote);

    if (result != null) {
      final index = notes.indexWhere((element) => element.id == result.id);
      if (index >= 0) notes[index] = result;
    }
    loading = false;
    try {
      notifyListeners();
    } catch (_) {}
  }

  void toDetail(BuildContext context, NoteType note) async {
    final res = await toNoteDetail(context, note);
    if (res == null) {
      notes.remove(note);
    } else {
      final index = notes.indexWhere((element) => element.id == res.id);
      if (index < 0) return;

      notes[index] = res;
    }

    try {
      notifyListeners();
    } catch (_) {}
  }

  static Widget provider(
    Widget Function(
      bool loading,
      List<NoteType> notes,
      VoidCallback createNote,
      void Function(NoteType) updatePin,
      void Function(NoteType) toDetail,
    )
        builder,
  ) {
    return ChangeNotifierProvider(
      create: (_) => NotesModel(),
      builder: (context, _) {
        final model = context.watch<NotesModel>();
        return builder(
          model.loading,
          model.notes,
          () => context.read<NotesModel>().createNote(context),
          (note) => context.read<NotesModel>().updatePin(note),
          (note) => context.read<NotesModel>().toDetail(context, note),
        );
      },
    );
  }
}
