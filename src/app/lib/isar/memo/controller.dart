import 'package:isar/isar.dart';

import '../../isar.g.dart';
import '../../types/MemoType.dart';
import '../../util/singleton.dart';
import '../collections/collection.dart';

class MemoController {
  static Future<MemoType?> get(String id) async {
    final isar = await CommonSingleton().isar;

    final collection = await isar.memoCollections.get(int.parse(id));
    if (collection == null) return null;

    return MemoType.fromCollection(collection);
  }

  static Future<List<MemoType>> getByNote(String id) async {
    final isar = await CommonSingleton().isar;

    final collections = await isar.memoCollections
        .where()
        .filter()
        .noteIdEqualTo(int.parse(id))
        .findAll();

    final list = <MemoType>[];
    for (var collection in collections) {
      list.add(MemoType.fromCollection(collection));
    }

    return list;
  }

  static Future<MemoType?> put(MemoType newMemo, String noteId) async {
    final collection = MemoCollection()
      ..noteId = int.parse(noteId)
      ..title = newMemo.title
      ..cost = newMemo.cost
      ..date = newMemo.date
      ..description = newMemo.description;

    if (newMemo.id != null) collection.id = int.parse(newMemo.id!);

    final isar = await CommonSingleton().isar;
    await isar.writeTxn((isar) async {
      await isar.memoCollections.put(collection);
    });

    return await get(collection.id.toString());
  }

  static Future<bool> delete(String id) async {
    final isar = await CommonSingleton().isar;
    await isar.writeTxn((isar) async {
      await isar.memoCollections.delete(int.parse(id));
    });

    final success = (await get(id)) == null;
    return success;
  }
}
