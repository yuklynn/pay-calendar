import '../database/collections/note.dart';
import '../theme.dart';

class NoteType {
  final String? id;
  final String name;
  final int color;
  final String? description;
  final bool pin;
  bool loaded;

  NoteType({
    this.id,
    required this.name,
    int? color,
    this.description,
    this.pin = false,
    this.loaded = false,
  }) : color = color ?? MainTheme.primaryColor.value;

  NoteType.noLoad({required this.name, int? color, this.description})
      : id = null,
        color = color ?? MainTheme.primaryColor.value,
        pin = false,
        loaded = true;

  NoteType.fromCollection(NoteCollection note)
      : id = note.id.toString(),
        name = note.name!,
        color = note.color ?? MainTheme.primaryColor.value,
        description = note.description,
        pin = note.pin!,
        loaded = true;

  NoteType edit({
    String? name,
    int? color,
    String? description,
    bool? pin,
  }) =>
      NoteType(
        id: id,
        name: name ?? this.name,
        color: color ?? this.color,
        description: description ?? this.description,
        pin: pin ?? this.pin,
      );
}
