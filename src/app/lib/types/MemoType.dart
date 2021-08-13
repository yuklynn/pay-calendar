import '../database/collections/memo.dart';

/// メモのデータ型
class MemoType {
  final String? id;
  final String title;
  final int? cost;
  final DateTime? date;
  final String? description;

  /// コンストラクタ
  MemoType({
    this.id,
    required this.title,
    this.cost,
    this.date,
    this.description,
  });

  /// DBコレクションからデータを作るコンストラクタ
  MemoType.fromCollection(MemoCollection collection)
      : id = collection.id.toString(),
        title = collection.title!,
        cost = collection.cost,
        date = collection.date,
        description = collection.description;

  /// データを変更するメソッド
  MemoType edit({
    String? title,
    int? cost,
    DateTime? date,
    String? description,
  }) =>
      MemoType(
        id: id,
        title: title ?? this.title,
        cost: cost ?? this.cost,
        date: date ?? this.date,
        description: description ?? this.description,
      );
}
