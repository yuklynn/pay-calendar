import '../database/collections/memo.dart';

class MemoType {
  final String? id;
  final String title;
  final int? cost;
  final DateTime? date;
  final String? description;

  MemoType({
    this.id,
    required this.title,
    this.cost,
    this.date,
    this.description,
  });

  MemoType.fromCollection(MemoCollection collection)
      : id = collection.id.toString(),
        title = collection.title!,
        cost = collection.cost,
        date = collection.date,
        description = collection.description;
}
