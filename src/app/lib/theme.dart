import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'util/colors.dart';

class MainTheme {
  final BuildContext context;
  static const primaryColor = Color(defaultColor);

  MainTheme(this.context);

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

  final outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: primaryColor),
      primary: primaryColor,
      textStyle: GoogleFonts.mPlus1p(),
    ),
  );

  final floatingActionButtonTheme = FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
  );

  TextButtonThemeData textButtonTheme(BuildContext context) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: primaryColor,
        textStyle: GoogleFonts.mPlus1p().copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: primaryColor,
      textStyle: GoogleFonts.mPlus1p(),
    ),
  );

  final dividerTheme = DividerThemeData(
    color: Color(dividerColor),
    space: 1.0,
  );

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

  IconThemeData iconTheme() {
    return IconThemeData(
      color: primaryColor,
    );
  }
}
