import 'package:flutter/material.dart';

import '../../components/common/ColorChoiceBottomSheet.dart';

/// 色選択のボトムシート表示
Future<int?> showColorChoiceBottomSheet(BuildContext context, int color) async {
  return await showModalBottomSheet<int>(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    context: context,
    builder: (context) => ColorChoiceBottomSheet(color: color),
  );
}
