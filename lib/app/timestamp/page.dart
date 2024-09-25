import 'package:bong_librarian_check/classes/class_library_timestamp.dart';
import 'package:bong_librarian_check/components/comp_navbar.dart';
import 'package:bong_librarian_check/helper/helper_daytime.dart';
import 'package:bong_librarian_check/providers/provider_librarian.dart';
import 'package:bong_librarian_check/providers/provider_timestamp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimestampPage extends StatefulWidget {
  const TimestampPage({super.key});

  @override
  State<TimestampPage> createState() => _TimestampPageState();
}

enum _ListViewSegment {
  today,
  week,
  month,
  all,
}

class _TimestampPageState extends State<TimestampPage> {
  List<LibraryTimestamp> _filteredTimestamps = [];
  _ListViewSegment selectedListViewSegment = _ListViewSegment.today;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final timestampProvider =
          Provider.of<ProviderTimestamp>(context, listen: false);
      timestampProvider.loadTimestamps();
      _filteredTimestamps = timestampProvider.data
          .where(
            (e) => isSameDay(DateTime.now(), e.timestamp),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final timestampProvider = Provider.of<ProviderTimestamp>(context);
    final librarianProvider = Provider.of<ProviderLibrarian>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("출석부"),
      ),
      body: Column(
        children: [
          SegmentedButton(
            segments: const <ButtonSegment<_ListViewSegment>>[
              ButtonSegment<_ListViewSegment>(
                  label: Text("오늘"), value: _ListViewSegment.today),
              ButtonSegment<_ListViewSegment>(
                  label: Text("금주"), value: _ListViewSegment.week),
              ButtonSegment<_ListViewSegment>(
                  label: Text("금월"), value: _ListViewSegment.month),
              ButtonSegment<_ListViewSegment>(
                  label: Text("전체"), value: _ListViewSegment.all),
            ],
            selected: <_ListViewSegment>{selectedListViewSegment},
            onSelectionChanged: (Set<_ListViewSegment> value) {
              setState(() {
                selectedListViewSegment = value.first;
                switch (selectedListViewSegment) {
                  case _ListViewSegment.today:
                    _filteredTimestamps = timestampProvider.data
                        .where(
                          (e) => isSameDay(DateTime.now(), e.timestamp),
                        )
                        .toList();
                    break;
                  case _ListViewSegment.week:
                    _filteredTimestamps = timestampProvider.data
                        .where(
                          (e) => isSameWeek(DateTime.now(), e.timestamp),
                        )
                        .toList();
                    break;
                  case _ListViewSegment.month:
                    _filteredTimestamps = timestampProvider.data
                        .where(
                          (e) => isSameMonth(DateTime.now(), e.timestamp),
                        )
                        .toList();
                    break;
                  case _ListViewSegment.all:
                    _filteredTimestamps = timestampProvider.data;
                    break;
                }
              });
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ListView.builder(
                reverse: true,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _filteredTimestamps.length,
                itemBuilder: (context, index) {
                  final timestamp = _filteredTimestamps[index];
                  final librarian =
                      librarianProvider.getLibrarian(timestamp.librarianUuid);
                  return ListTile(
                    leading: Text('${index + 1}'),
                    title: Text(
                        librarian.isSuccess ? librarian.data!.name : 'no user'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Timestamp: ${timestamp.timestamp}"),
                        Text(
                            "ExitTimestamp: ${timestamp.exitTimestamp ?? "no"}"),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CompNavbar(),
    );
  }
}
