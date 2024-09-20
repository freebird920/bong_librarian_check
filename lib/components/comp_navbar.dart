import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CompNavbar extends StatefulWidget {
  const CompNavbar({super.key});

  @override
  State<CompNavbar> createState() => _CompNavbarState();
}

class _CompNavbarState extends State<CompNavbar> {
  late int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    final uri = GoRouter.of(context).routeInformationProvider.value.uri;
    final myUriSplit = uri.toString().split("/");
    final myUri = Uri.parse("/${myUriSplit[1]}");
    switch (myUri.toString()) {
      case "/":
        _selectedIndex = 0;
        break;
      case "/settings":
        _selectedIndex = 2;
      default:
        _selectedIndex = 0;
        break;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myUri = GoRouter.of(context).routeInformationProvider.value.uri;
    print(myUri.toString());
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (final int value) {
        final goRouter = GoRouter.of(context);
        switch (value) {
          case 0:
            goRouter.go("/");
            break;
          case 2:
            goRouter.go("/settings");
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
      ],
    );
  }
}
