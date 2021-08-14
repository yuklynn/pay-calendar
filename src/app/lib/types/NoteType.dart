import '../isar/note/collection.dart';
import '../util/theme.dart';

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
  NoteType.fromCollection(NoteCollection collection)
      : id = collection.id.toString(),
        title = collection.title!,
        color = collection.color ?? MainTheme.primaryColor.value,
        description = collection.description,
        pin = collection.pin!;

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
