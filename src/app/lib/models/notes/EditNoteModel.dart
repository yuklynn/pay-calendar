import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../actions/common/navigation.dart';
import '../../database/controllers/NoteController.dart';
import '../../types/NoteType.dart';

class EditNoteModel with ChangeNotifier {
  final NoteType note;
  late TextEditingController nameController;
  late int color;
  late TextEditingController descriptionController;

  EditNoteModel({
    required this.note,
  }) {
    nameController = TextEditingController(text: note.name);
    descriptionController = TextEditingController(text: note.description);
    color = note.color;

    nameController.addListener(() {
      try{
        notifyListeners();
      }catch(_){}
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void showColorChoice(BuildContext context) async {
    final newColor = await showColorChoiceBottomSheet(context, color);
    if (newColor == null) return;

    color = newColor;
    try {
      notifyListeners();
    } catch (_) {}
  }

  void save(BuildContext context) async {
    final newNote = note.edit(
      name: nameController.text,
      color: color,
      description: descriptionController.text,
    );
    final result = await NoteController.put(newNote);
    Navigator.pop(context, result != null);
  }

  static Widget provider(
    Widget Function(
      TextEditingController,
      int,
      TextEditingController,
      VoidCallback,
      VoidCallback,
    )
        builder,
    NoteType note,
  ) {
    return ChangeNotifierProvider(
      create: (context) => EditNoteModel(note: note),
      builder: (context, _) {
        final model = context.watch<EditNoteModel>();
        return WillPopScope(
          child: builder(
            model.nameController,
            model.color,
            model.descriptionController,
            () => context.read<EditNoteModel>().showColorChoice(context),
            () => context.read<EditNoteModel>().save(context),
          ),
          onWillPop: () async {
            Navigator.pop(context, false);
            return true;
          },
        );
      },
    );
  }
}
