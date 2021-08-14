import 'package:flutter/material.dart';

/// 画面遷移のルート
class NavigationRoute {
  /// 潜る遷移
  static Route<T> forward<T>({Widget? page}) => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page!,
        transitionDuration: Duration(milliseconds: 300),
        reverseTransitionDuration: Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // 右から左にアニメーションする
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.easeInOutSine;
          var tween = Tween(begin: begin, end: end);
          var curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
      );

  /// ダイアログの遷移
  static Route<T> dialog<T>({Widget? page}) => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page!,
        fullscreenDialog: true,
        transitionDuration: Duration(milliseconds: 300),
        reverseTransitionDuration: Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // 下から上にアニメーションする
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.easeInOutSine;
          var tween = Tween(begin: begin, end: end);
          var curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
      );
}
