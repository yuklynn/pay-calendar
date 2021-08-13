import '../isar/collections/collection.dart';
import '../theme.dart';

/// ノートのデータ型
class NoteType {
  final String? id;
  final String title;
  final int color;
  final String? description;
  final bool pin;

  /// コンストラクタ
  NoteType({
    this.id,
    required this.title,
    int? color,
    this.description,
    this.pin = false,
  }) : color = color ?? MainTheme.primaryColor.value;

  /// DBのコレクションから作るデータ型
  NoteType.fromCollection(NoteCollection note)
      : id = note.id.toString(),
        title = note.title!,
        color = note.color ?? MainTheme.primaryColor.value,
        description = note.description,
        pin = note.pin!;

  /// データを変更するメソッド
  NoteType edit({
    String? title,
    int? color,
    String? description,
    bool? pin,
  }) =>
      NoteType(
        id: id,
        title: title ?? this.title,
        color: color ?? this.color,
        description: description ?? this.description,
        pin: pin ?? this.pin,
      );
}
