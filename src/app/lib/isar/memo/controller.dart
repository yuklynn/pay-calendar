import 'package:isar/isar.dart';

import '../../isar.g.dart';
import '../../types/MemoType.dart';
import '../../util/singleton.dart';
import 'collection.dart';

/// メモのIsarコントローラー
class MemoController {
  late Isar isar; // Isarインターフェース

  /// コンストラクタ
  MemoController() {
    // 初期処理
    _init();
  }

  /// 初期処理
  void _init() {
    // Isarインターフェースを作る
    isar = CommonSingleton().isar;
  }

  /// 1件取得
  Future<MemoType?> get(int id) async {
    // 1件取得する
    final collection = await isar.memoCollections.get(id);

    if (collection == null) return null;
    return MemoType.fromCollection(collection);
  }

  /// ノートIDから一覧取得
  Future<List<MemoType>> getByNote(int id) async {
    // ノートIDでフィルターして一覧を取得する
    final collections =
        await isar.memoCollections.where().filter().noteIdEqualTo(id).findAll();

    // メモのデータ型のリストに変換
    final list = <MemoType>[];
    for (var collection in collections) {
      list.add(MemoType.fromCollection(collection));
    }
    return list;
  }

  /// 1件作成・更新
  Future<MemoType?> createOrUpdate(MemoType memo, int noteId) async {
    // メモのIsarコレクションに変換
    final collection = MemoCollection()
      ..noteId = noteId
      ..title = memo.title
      ..cost = memo.cost
      ..date = memo.date
      ..description = memo.description
      ..done = memo.done;
    if (memo.id != null) collection.id = int.parse(memo.id!);

    await isar.writeTxn((isar) async {
      await isar.memoCollections.put(collection);
    });
    return await get(collection.id!);
  }

  /// 1件削除
  Future<bool> delete(int id) async {
    await isar.writeTxn((isar) async {
      await isar.memoCollections.delete(id);
    });

    // なぜかdeleteはfalseを返すので取得できるかどうかを返す
    final memo = await get(id);
    return (memo == null);
  }
}
