import 'package:isar/isar.dart';

@Collection()
class MemoCollection {
  @Id()
  int? id;

  int? noteId;

  String? title;

  int? cost;

  DateTime? date;

  String? description;
}
