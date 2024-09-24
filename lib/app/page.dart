// HomePage.dart

// pub packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import 'package:bong_librarian_check/providers/provider_librarian.dart';

// Enums
import 'package:bong_librarian_check/enums/enum_list_view_librarians_segment.dart';

// Classes
import 'package:bong_librarian_check/classes/class_result.dart';

// Components
import 'package:bong_librarian_check/app/home/components/list_tile_librarian.dart';
import 'package:bong_librarian_check/components/comp_navbar.dart';

// helpers
import 'package:bong_librarian_check/helper/day_of_week_parser.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DateTime now = DateTime.now();
  ListViewLibrariansSegment selectedViewSegment =
      ListViewLibrariansSegment.attention;

  final Result<String> dayOfWeekString =
      dayOfWeekParser(DateTime.now().weekday);

  @override
  Widget build(BuildContext context) {
    final librarianProvider = Provider.of<ProviderLibrarian>(context);
    final librarians = librarianProvider.data;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("도서부 출석 체크"),
        actions: [
          IconButton(
            icon: const Icon(Icons.addchart),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("오늘은 ${dayOfWeekString.data}요일 입니다."),
            ),
            SegmentedButton(
              segments: const <ButtonSegment<ListViewLibrariansSegment>>[
                ButtonSegment(
                  label: Text("즐근"),
                  value: ListViewLibrariansSegment.attention,
                ),
                ButtonSegment(
                  label: Text("퇴근"),
                  value: ListViewLibrariansSegment.exit,
                ),
              ],
              selected: <ListViewLibrariansSegment>{selectedViewSegment},
              onSelectionChanged: (Set<ListViewLibrariansSegment> value) {
                setState(() {
                  selectedViewSegment = value.first;
                });
              },
            ),
            Expanded(
              child: ListViewLibrarians(
                librarians: librarians,
                selectedViewSegment: selectedViewSegment,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CompNavbar(),
    );
  }
}
