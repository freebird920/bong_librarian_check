import 'package:bong_librarian_check/app/page.dart';
import 'package:bong_librarian_check/app/settings/page.dart';
import 'package:bong_librarian_check/app/settings/set_librarians/page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    ],
  ),
];

// Create Router
final GoRouter _router = GoRouter(routes: _routes);

// Root Layout
class RootLayout extends StatelessWidget {
  const RootLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
