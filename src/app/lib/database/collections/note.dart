import 'package:isar/isar.dart';

@Collection()
class NoteCollection {
  @Id()
  int? id;
  String? name;
  int? color;
  String? description;
  bool? pin;
}

@Collection()
class LastShownNoteCollection {
  @Id()
  int? id;

  IsarLink<NoteCollection> note = IsarLink<NoteCollection>();
}
