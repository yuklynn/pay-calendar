import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'components/Home/Home.dart';
import 'theme.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flutter Demo',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ja', ''),
      ],
      theme: MainTheme(context).theme,
      home: Home(),
    );
  }
}
