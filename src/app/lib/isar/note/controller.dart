import 'package:isar/isar.dart';

import '../../isar.g.dart';
import '../../types/NoteType.dart';
import '../../util/singleton.dart';
import 'collection.dart';

/// ノートのコントローラー
class NoteController {
  late Isar isar; // Isarインターフェース

  NoteController() {
    // 初期処理
    _init();
  }

  /// 初期処理
  void _init() async {
    isar = await CommonSingleton().isar;
  }

  /// 1件取得
  Future<NoteType?> get(int id) async {
    // 1件取得する
    final collection = await isar.noteCollections.get(id);

    if (collection == null) return null;
    return NoteType.fromCollection(collection);
  }

  /// 一覧取得
  Future<List<NoteType>> getAll() async {
    // 全件取得する
    final collections = await isar.noteCollections.where().findAll();

    // ノートのデータ型のリストに変換
    final list = <NoteType>[];
    for (var collection in collections) {
      list.add(NoteType.fromCollection(collection));
    }
    return list;
  }

  /// ピン留めされたノートを取得
  Future<List<NoteType>> getPinned() async {
    // ピン留めされた一覧を取得
    final collections =
        await isar.noteCollections.where().filter().pinEqualTo(true).findAll();

    // ノートのデータ型のリストに変換
    final list = <NoteType>[];
    for (var collection in collections) {
      list.add(NoteType.fromCollection(collection));
    }
    return list;
  }

  /// 最後に表示したノートを取得
  Future<NoteType?> getLastShown() async {
    // 最後に表示したノートのうち最初の1件を取得
    final collection = await isar.lastShownNoteCollections.where().findFirst();

    if (collection == null) return null;
    if (collection.note.value == null) return null;
    return NoteType.fromCollection(collection.note.value!);
  }

  /// 1件作成・変更
  Future<NoteType?> createOrUpdate(NoteType note) async {
    // Isarコレクションに変換
    final collection = NoteCollection()
      ..title = note.title
      ..color = note.color
      ..description = note.description
      ..pin = note.pin;
    if (note.id != null) collection.id = int.parse(note.id!);

    // 作成または変更
    await isar.writeTxn((isar) async {
      await isar.noteCollections.put(collection);
    });
    return await get(collection.id!);
  }

  /// 最後に表示したノートを更新
  Future<void> updateLastShown(NoteType note) async {
    // Isarコレクションに変換
    final noteCollection = NoteCollection()
      ..id = int.parse(note.id!)
      ..title = note.title
      ..color = note.color
      ..description = note.description
      ..pin = note.pin;
    final collection = LastShownNoteCollection()..note.value = noteCollection;

    await isar.writeTxn((isar) async {
      // テーブルクリア
      await isar.lastShownNoteCollections.where().deleteAll();

      // 新規にデータ挿入
      await isar.lastShownNoteCollections.put(collection);
    });
  }

  /// 1件削除
  Future<bool> delete(int id) async {
    // 1件削除
    var success = false;
    await isar.writeTxn((isar) async {
      success = await isar.noteCollections.delete(id);
    });
    return success;
  }
}
