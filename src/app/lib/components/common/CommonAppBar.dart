import 'package:flutter/material.dart';

import '../../util/colors.dart';

/// 共通AppBarの表示Widget
class CommonAppBar extends AppBar {
  final Widget? title;
  final List<Widget>? actions;

  CommonAppBar({
    this.title,
    this.actions,
  }) : super(title: title, actions: actions);

  @override
  ShapeBorder? get shape => Border(
        bottom: BorderSide(
          color: Color(dividerColor),
          width: 0.5,
        ),
      );
}
