import 'package:isar/isar.dart';

import '../isar.g.dart';

class CommonSingleton {
  static CommonSingleton? _ins;
  static Isar? _isar;
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
