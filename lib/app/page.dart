// HomePage.dart
import 'dart:math';

import 'package:bong_librarian_check/classes/class_library_timestamp.dart';
import 'package:bong_librarian_check/providers/provider_timestamp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Components
import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/classes/class_result.dart';
import 'package:bong_librarian_check/components/comp_navbar.dart';
import 'package:bong_librarian_check/helper/day_of_week_parser.dart';
import 'package:bong_librarian_check/providers/provider_librarian.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DateTime now = DateTime.now();

  final Result<String> dayOfWeekString =
      dayOfWeekParser(DateTime.now().weekday);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProviderLibrarian>(context, listen: false).loadLibrarians();
    });
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
        title: const Text(
          "도서부 출석 체크",
          style: TextStyle(
            fontFamily: "NotoSansKR",
            fontWeight: FontWeight.w700,
            textBaseline: TextBaseline.ideographic,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "오늘은 ${dayOfWeekString.data}요일 입니다.",
                style: const TextStyle(
                  fontFamily: "NotoSansKR",
                  fontWeight: FontWeight.w700,
                  textBaseline: TextBaseline.ideographic,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredLibrarians.length,
                itemBuilder: (context, index) {
                  final timestampProvider =
                      Provider.of<ProviderTimestamp>(context);
                  return ListTile(
                    leading: Text(" ${index + 1}"),
                    title: Text(filteredLibrarians[index].name),
                    subtitle: Text(
                        "Student ID: ${filteredLibrarians[index].studentId}"),
                    trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          timestampProvider.saveTimestamp(
                            LibraryTimestamp(
                              librarianUuid: filteredLibrarians[index].uuid,
                              timestamp: DateTime.now(),
                            ),
                          );
                        }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CompNavbar(),
    );
  }
}
