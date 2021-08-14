import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

/// メインテーマ
class MainTheme {
  final BuildContext context;
  static const primaryColor = Color(defaultColor);

  MainTheme(this.context);

  /// テーマのゲッター
  ThemeData get theme => ThemeData(
        primaryColor: primaryColor,
        accentColor: primaryColor,
        textTheme: GoogleFonts.mPlus1pTextTheme(Theme.of(context).textTheme),
        iconTheme: iconTheme(),
        outlinedButtonTheme: outlinedButtonTheme,
        floatingActionButtonTheme: floatingActionButtonTheme,
        textButtonTheme: textButtonTheme(context),
        elevatedButtonTheme: elevatedButtonTheme,
        dividerTheme: dividerTheme,
        appBarTheme: appBarTheme(context),
      );

  /// アウトラインボタンのテーマ
  final outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: primaryColor),
      primary: primaryColor,
      textStyle: GoogleFonts.mPlus1p(),
    ),
  );

  /// FABのテーマ
  final floatingActionButtonTheme = FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
  );

  /// テキストボタンのテーマ
  TextButtonThemeData textButtonTheme(BuildContext context) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: primaryColor,
        textStyle: GoogleFonts.mPlus1p().copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  /// 塗りつぶしボタンのテーマ
  final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: primaryColor,
      textStyle: GoogleFonts.mPlus1p(),
    ),
  );

  /// 区切り線のテーマ
  final dividerTheme = DividerThemeData(
    color: Color(dividerColor),
    space: 1.0,
  );

  /// ヘッダーのテーマ
  AppBarTheme appBarTheme(BuildContext context) {
    final theme = Theme.of(context);

    return AppBarTheme(
      backgroundColor: theme.canvasColor,
      foregroundColor: primaryColor,
      iconTheme: iconTheme(),
      elevation: 0.0,
      textTheme: GoogleFonts.mPlus1pTextTheme(theme.textTheme),
    );
  }

  /// アイコンのテーマ
  IconThemeData iconTheme() {
    return IconThemeData(
      color: primaryColor,
    );
  }
}
