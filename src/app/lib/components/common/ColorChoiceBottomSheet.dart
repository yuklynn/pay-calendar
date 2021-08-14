import 'package:flutter/material.dart';

import '../../util/colors.dart';
import 'CommonBottomSheet.dart';
import 'DisableScrollGlow.dart';

/// 色選択ボトムシート
class ColorChoiceBottomSheet extends StatelessWidget {
  final int color;

  ColorChoiceBottomSheet({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      body: Expanded(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return DisableScrollGlow(
      child: ListView.builder(
        itemCount: ThemeColor.values.length,
        itemBuilder: (context, index) {
          final color = ThemeColor.values[index];

          return ListTile(
            leading: CircleAvatar(
              radius: 12.0,
              backgroundColor: color.color,
            ),
            title: Text(
              color.name,
              style: TextStyle(
                fontWeight:
                    color.color.value == this.color ? FontWeight.bold : null,
              ),
            ),
            onTap: () {
              Navigator.pop(context, color.color.value);
            },
          );
        },
      ),
    );
  }
}
