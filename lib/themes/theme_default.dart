import 'package:flutter/material.dart';

final myColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.indigo,
  brightness: Brightness.dark,
);
ThemeData defaultTheme = ThemeData(
  colorScheme: myColorScheme,
  // canvasColor: myColorScheme.surface,
  // scaffoldBackgroundColor: myColorScheme.surface,
  // focusColor: myColorScheme.inversePrimary,

  fontFamily: "NotoSansKR",

  // primaryColor: const Color(0xFF3F51B5),
);
