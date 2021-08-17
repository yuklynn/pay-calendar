import 'package:flutter/material.dart';

/// オーバースクロールのエフェクトを無効化するWidget
class DisableScrollGlow extends StatelessWidget {
  final Widget child;

  DisableScrollGlow({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return false;
      },
      child: child,
    );
  }
}
