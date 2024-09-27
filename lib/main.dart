// import libraries
import 'package:bong_librarian_check/providers/provider_preference.dart';
import 'package:bong_librarian_check/providers/provider_timestamp.dart';
import 'package:bong_librarian_check/providers/provider_version.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//
import 'package:bong_librarian_check/app/layout.dart';
import 'package:bong_librarian_check/providers/provider_librarian.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderLibrarian()),
        ChangeNotifierProvider(create: (_) => ProviderTimestamp()),
        ChangeNotifierProvider(create: (_) => ProviderVersion()),
        ChangeNotifierProvider(create: (_) => ProviderPreference()),
      ],
      child: const RootLayout(),
    ),
  );
}
