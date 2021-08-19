import 'package:intl/intl.dart';

/// フォーマットされた数字を取得する
String formatNumber(int num) {
  final text = NumberFormat('#,###').format(num);

  return text;
}
