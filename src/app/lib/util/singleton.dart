import 'package:isar/isar.dart';

import '../isar.g.dart';

/// 共通のシングルトン
class CommonSingleton {
  static Isar? _isar; // Isarインターフェース

  static CommonSingleton? _ins;
  const CommonSingleton._();

  factory CommonSingleton() {
    if (_ins == null) _ins = CommonSingleton._();
    return _ins!;
  }

  Future<Isar> get isar async {
    if (_isar == null) _isar = await openIsar();
    return _isar!;
  }
}
