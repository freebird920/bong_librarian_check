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
    final myUri = GoRouter.of(context).routeInformationProvider.value.uri;
    switch (myUri.toString()) {
      case "/":
        _selectedIndex = 0;
        break;
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
        switch (value) {
          case 0:
            print(value.toString());
            GoRouter.of(context).go("/");
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
