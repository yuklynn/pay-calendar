import '../../isar/note/controller.dart';
import '../../types/NoteType.dart';

/// ノートを1件取得する
Future<NoteType?> getNote(String id) async {
  final controller = NoteController();
  try {
    final result = await controller.get(int.parse(id));
    return result;
  } catch (e) {
    // todo: エラー処理
    print('exception: $e');
  }
}

/// ノート一覧を取得する
Future<List<NoteType>?> getNoteList() async {
  final controller = NoteController();
  try {
    final result = await controller.getAll();
    return result;
  } catch (e) {
    // todo: エラー処理
    print('exception: $e');
  }
}

/// ピン留めされたノート一覧を取得する
Future<List<NoteType>?> getPinnedNoteList() async {
  final controller = NoteController();
  try {
    final result = await controller.getPinned();
    return result;
  } catch (e) {
    // todo: エラー処理
    print('exception: $e');
  }
}

/// 最後に表示したノートを取得する
Future<NoteType?> getLastShownNote() async {
  final controller = NoteController();
  try {
    final result = await controller.getLastShown();
    return result;
  } catch (e) {
    // todo: エラー処理
    print('exception: $e');
  }
}

/// ノートを作成・更新する
Future<NoteType?> createOrUpdateNote(NoteType note) async {
  final controller = NoteController();
  try {
    final result = await controller.createOrUpdate(note);
    return result;
  } catch (e) {
    // todo: エラー処理
    print('exception: $e');
  }
}

/// 最後に表示したノートを更新する
Future<bool> updateLastShownNote(NoteType note) async {
  final controller = NoteController();
  try {
    await controller.updateLastShown(note);
    return true;
  } catch (e) {
    // todo: エラー処理
    print('exception: $e');
    return false;
  }
}

/// ノートを削除する
Future<bool> deleteNote(String id) async {
  final controller = NoteController();
  try {
    final result = await controller.delete(int.parse(id));
    return result;
  } catch (e) {
    // todo: エラー処理
    print('exception: $e');
    return false;
  }
}
