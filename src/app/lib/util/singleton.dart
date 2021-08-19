import 'package:isar/isar.dart';
import 'package:pay_calendar/isar.g.dart';

/// 共通のシングルトン
class CommonSingleton {
  late Isar _isar; // Isarインターフェース

  static CommonSingleton? _ins;
  CommonSingleton._();

  factory CommonSingleton() {
    if (_ins == null) _ins = CommonSingleton._();
    return _ins!;
  }

  Future<void> initIsar() async {
    _isar = await openIsar();
  }

  Isar get isar => _isar;
}
