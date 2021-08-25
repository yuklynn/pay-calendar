import '../../isar/memo/controller.dart';
import '../../types/MemoType.dart';

/// メモ一覧を取得する
Future<List<MemoType>?> getMemoList(String noteId, {bool done = false}) async {
  final controller = MemoController();
  try {
    final result = controller.getByNote(int.parse(noteId), done: done);
    return result;
  } catch (e) {
    // todo: エラー処理
    print('exception: $e');
  }
}

/// メモを作成・更新する
Future<MemoType?> createOrUpdateMemo(MemoType memo, String noteId) async {
  final controller = MemoController();
  try {
    final result = controller.createOrUpdate(memo, int.parse(noteId));
    return result;
  } catch (e) {
    // todo: エラー処理
    print('exception: $e');
  }
}

/// メモを削除する
Future<bool> deleteMemo(String id) async {
  final controller = MemoController();
  try {
    final result = controller.delete(int.parse(id));
    return result;
  } catch (e) {
    // todo: エラー処理
    print('exception: $e');
    return false;
  }
}
