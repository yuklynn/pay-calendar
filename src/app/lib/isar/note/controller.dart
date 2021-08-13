import 'package:isar/isar.dart';

import '../../isar.g.dart';
import '../../types/NoteType.dart';
import '../../util/singleton.dart';
import '../collections/collection.dart';

class NoteController {
  static Future<NoteType?> get(String id) async {
    final isar = await CommonSingleton().isar;
    final collection = await isar.noteCollections.get(int.parse(id));
    if (collection == null) return null;

    return NoteType.fromCollection(collection);
  }

  static Future<List<NoteType>> getAll() async {
    final isar = await CommonSingleton().isar;
    final collections = await isar.noteCollections.where().findAll();

    final list = <NoteType>[];
    for (var collection in collections) {
      list.add(
        NoteType.fromCollection(collection),
      );
    }

    return list;
  }

  static Future<List<NoteType>> getPinned() async {
    final isar = await CommonSingleton().isar;
    final collections =
        await isar.noteCollections.where().filter().pinEqualTo(true).findAll();

    final list = <NoteType>[];
    for (var collection in collections) {
      list.add(NoteType.fromCollection(collection));
    }

    return list;
  }

  static Future<NoteType?> getLastShown() async {
    final isar = await CommonSingleton().isar;
    final collection = await isar.lastShownNoteCollections.where().findFirst();
    if (collection == null) return null;
    if (collection.note.value == null) return null;

    return NoteType.fromCollection(collection.note.value!);
  }

  static Future<NoteType?> put(NoteType newNote) async {
    final collection = NoteCollection()
      ..title = newNote.title
      ..color = newNote.color
      ..description = newNote.description
      ..pin = newNote.pin;
    if (newNote.id != null) collection.id = int.parse(newNote.id!);

    final isar = await CommonSingleton().isar;
    await isar.writeTxn((isar) async {
      await isar.noteCollections.put(collection);
    });
    return await get(collection.id.toString());
  }

  static void putLastShown(NoteType note) async {
    final noteCollection = NoteCollection()
      ..id = int.parse(note.id!)
      ..title = note.title
      ..color = note.color
      ..description = note.description
      ..pin = note.pin;
    final collection = LastShownNoteCollection()..note.value = noteCollection;

    final isar = await CommonSingleton().isar;
    await isar.writeTxn((isar) async {
      await isar.lastShownNoteCollections.where().deleteAll();
      await isar.lastShownNoteCollections.put(collection);
    });
  }

  static Future<bool> delete(String id) async {
    final isar = await CommonSingleton().isar;
    await isar.writeTxn((isar) async {
      await isar.noteCollections.delete(int.parse(id));
    });

    final success = (await get(id)) == null;
    return success;
  }
}
