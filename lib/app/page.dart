// HomePage.dart
import 'package:bong_librarian_check/app/home/list_tile_librarian.dart';
import 'package:bong_librarian_check/providers/provider_timestamp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Components
import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/classes/class_result.dart';
import 'package:bong_librarian_check/components/comp_navbar.dart';
import 'package:bong_librarian_check/helper/day_of_week_parser.dart';
import 'package:bong_librarian_check/providers/provider_librarian.dart';

enum _MyViewSegment {
  attention,
  exit,
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DateTime now = DateTime.now();
  _MyViewSegment selectedViewSegment = _MyViewSegment.attention;

  final Result<String> dayOfWeekString =
      dayOfWeekParser(DateTime.now().weekday);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<ProviderLibrarian>(context, listen: false).loadLibrarians();
        Provider.of<ProviderTimestamp>(context, listen: false).loadTimestamps();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final librarianProvider = Provider.of<ProviderLibrarian>(context);
    final librarians = librarianProvider.data;
    List<Librarian> filteredLibrarians = librarians
        .where(
          (e) => e.workDays!.contains(now.weekday),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("도서부 출석 체크"),
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
              segments: const <ButtonSegment<_MyViewSegment>>[
                ButtonSegment(
                    label: Text("즐근"), value: _MyViewSegment.attention),
                ButtonSegment(label: Text("퇴근"), value: _MyViewSegment.exit),
              ],
              selected: <_MyViewSegment>{selectedViewSegment},
              onSelectionChanged: (Set<_MyViewSegment> value) {
                setState(() {
                  selectedViewSegment = value.first;
                });
              },
            ),
            Expanded(
              child: ListViewLibrarians(filteredLibrarians: filteredLibrarians),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CompNavbar(),
    );
  }
}
