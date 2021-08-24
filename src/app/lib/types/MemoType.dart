import '../isar/memo/collection.dart';

/// メモのデータ型
class MemoType {
  /// ID
  final String? id;

  /// タイトル
  final String title;

  /// 金額
  final int? cost;

  /// 日付
  final DateTime? date;

  /// 説明
  final String? description;

  /// 完了フラグ
  final bool done;

  /// コンストラクタ
  MemoType({
    this.id,
    required this.title,
    this.cost,
    this.date,
    this.description,
    this.done = false,
  });

  /// DBコレクションからデータを作るコンストラクタ
  MemoType.fromCollection(MemoCollection collection)
      : id = collection.id.toString(),
        title = collection.title ?? '',
        cost = collection.cost,
        date = collection.date,
        description = collection.description,
        done = collection.done ?? false;

  /// データを変更するメソッド
  MemoType edit({
    String? title,
    int? cost,
    DateTime? date,
    String? description,
    bool? done,
  }) =>
      MemoType(
        id: id,
        title: title ?? this.title,
        cost: cost ?? this.cost,
        date: date ?? this.date,
        description: description ?? this.description,
        done: done ?? this.done,
      );
}
