import 'package:isar/isar.dart';

/// ノートのIsarコレクション
@Collection()
class NoteCollection {
  @Id()
  int? id;
  String? title;
  int? color;
  String? description;
  bool? pin;
}

/// 最後に表示したノートのIsarコレクション
@Collection()
class LastShownNoteCollection {
  @Id()
  int? id;

  IsarLink<NoteCollection> note = IsarLink<NoteCollection>();
}
