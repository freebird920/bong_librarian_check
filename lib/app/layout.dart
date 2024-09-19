import 'package:bong_librarian_check/app/page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> _routes = <RouteBase>[
  GoRoute(
    path: "/",
    builder: (context, state) => const HomePage(),
  ),
];

final GoRouter _router = GoRouter(routes: _routes);

class RootLayout extends StatelessWidget {
  const RootLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
