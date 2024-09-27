import 'package:bong_librarian_check/app/page.dart';
import 'package:bong_librarian_check/app/settings/page.dart';
import 'package:bong_librarian_check/app/settings/set_librarians/page.dart';
import 'package:bong_librarian_check/app/settings/set_theme/page.dart';
import 'package:bong_librarian_check/app/timestamp/page.dart';
import 'package:bong_librarian_check/providers/provider_preference.dart';
import 'package:bong_librarian_check/themes/theme_default.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Set Routes
final List<RouteBase> _routes = <RouteBase>[
  GoRoute(
    path: "/",
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
    path: "/settings",
    builder: (context, state) => const SettingsPage(),
    routes: <RouteBase>[
      GoRoute(
        path: "set_librarians",
        builder: (context, state) => const SetLibrarinasPage(),
      ),
      GoRoute(
        path: "set_theme",
        builder: (context, state) => const SetThemePage(),
      )
    ],
  ),
  GoRoute(
    path: "/timestamp",
    builder: (context, state) => const TimestampPage(),
  )
];

// Create Router
final GoRouter _router = GoRouter(routes: _routes);

// Root Layout
class RootLayout extends StatelessWidget {
  const RootLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderPreference>(
        builder: (context, preferenceProvider, child) {
      final bool darkMode =
          preferenceProvider.getPrefBool("dark_mode") ?? false;
      return MaterialApp.router(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: darkMode ? Brightness.dark : Brightness.light,
          ),
          // canvasColor: myColorScheme.surface,
          // scaffoldBackgroundColor: myColorScheme.surface,
          // focusColor: myColorScheme.inversePrimary,

          fontFamily: "NotoSansKR",

          // primaryColor: const Color(0xFF3F51B5),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
      );
    });
  }
}
