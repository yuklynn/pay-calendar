import 'package:flutter/material.dart';

/// リストの下限を示すインジケーター
class ListBottomIndicator extends StatelessWidget {
  const ListBottomIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: CircleAvatar(
        radius: 2.0,
        backgroundColor: Colors.grey,
      ),
    );
  }
}
