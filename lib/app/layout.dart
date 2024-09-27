// import flutter
import 'package:flutter/material.dart';

// import pub packages
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// import providers
import 'package:bong_librarian_check/providers/provider_preference.dart';

// import routes
import 'package:bong_librarian_check/app/settings/page.dart';
import 'package:bong_librarian_check/app/settings/set_librarians/page.dart';
import 'package:bong_librarian_check/app/settings/set_theme/page.dart';
import 'package:bong_librarian_check/app/timestamp/page.dart';
import 'package:bong_librarian_check/app/page.dart';

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
        final int? myColorScheme = preferenceProvider.getPrefInt("theme_color");
        return MaterialApp.router(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(myColorScheme ??
                  const Color.fromARGB(255, 110, 243, 33).value),
              brightness: darkMode ? Brightness.dark : Brightness.light,
            ),
            fontFamily: "NotoSansKR",
          ),
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
        );
      },
    );
  }
}
