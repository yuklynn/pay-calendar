import 'package:flutter/material.dart';

/// ボトムシート共通
class CommonBottomSheet extends StatelessWidget {
  final Widget? body;

  CommonBottomSheet({
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeaderBar(),
        body ?? const SizedBox(),
        SizedBox(
          height: MediaQuery.of(context).viewInsets.bottom,
        )
      ],
    );
  }

  /// ボトムシート上部の横棒
  Widget _buildHeaderBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      height: 4.0,
      width: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.grey, // todo: color
      ),
    );
  }
}
