// import pub packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import providers
import 'package:bong_librarian_check/providers/provider_timestamp.dart';

// import classes
import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/classes/class_library_timestamp.dart';

// import enums
import 'package:bong_librarian_check/enums/enum_list_view_librarians_segment.dart';

class ListViewLibrarians extends StatefulWidget {
  const ListViewLibrarians({
    super.key,
    required this.librarians,
    required this.selectedViewSegment,
  });
  final List<Librarian> librarians;
  final ListViewLibrariansSegment selectedViewSegment;

  @override
  State<ListViewLibrarians> createState() => _ListViewLibrariansState();
}

class _ListViewLibrariansState extends State<ListViewLibrarians> {
  // filtered librarians
  List<Librarian> _filteredLibrarins = [];

  @override
  Widget build(BuildContext context) {
    //
    final ProviderTimestamp timestampProvider =
        Provider.of<ProviderTimestamp>(context);

    // filter librarians based on selected segment
    switch (widget.selectedViewSegment) {
      case ListViewLibrariansSegment.attention:
        _filteredLibrarins = widget.librarians.where(
          (e) {
            List<int> workDays = e.workDays ?? [];
            return workDays.contains(DateTime.now().weekday);
          },
        ).toList();
        break;
      case ListViewLibrariansSegment.exit:
        final List<LibraryTimestamp> todayTimestamp =
            timestampProvider.getTodaysTimestamps().data ??
                <LibraryTimestamp>[];
        final List<String> todayCheckedLibrarianUuids =
            todayTimestamp.map((e) => e.librarianUuid).toSet().toList();
        _filteredLibrarins = widget.librarians.where(
          (e) {
            String myUuid = e.uuid;
            return todayCheckedLibrarianUuids.contains(myUuid);
          },
        ).toList();
        break;
    }

    return ListView.builder(
      itemCount: _filteredLibrarins.length,
      itemBuilder: (context, index) {
        final thisLibrarian = _filteredLibrarins[index];
        final myTimestamps = timestampProvider
                .getTimestampsByDayLibrarianUuid(
                    librarianUuid: thisLibrarian.uuid, thisDay: DateTime.now())
                .data ??
            <LibraryTimestamp>[];

        return ListTile(
          leading: Text((index + 1).toString()),
          title: Text('[${thisLibrarian.enteranceYear}] ${thisLibrarian.name}'),
          subtitle: Text(thisLibrarian.studentId.toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.selectedViewSegment ==
                  ListViewLibrariansSegment.attention)
                IconButton(
                    onPressed: (myTimestamps.isEmpty ||
                            myTimestamps.last.exitTimestamp is DateTime)
                        ? () async {
                            final LibraryTimestamp newTimestamp =
                                LibraryTimestamp(
                              librarianUuid: thisLibrarian.uuid,
                              timestamp: DateTime.now(),
                            );
                            await timestampProvider.saveTimestamp(newTimestamp);
                          }
                        : null,
                    icon: const Icon(Icons.check)),
              if (widget.selectedViewSegment == ListViewLibrariansSegment.exit)
                IconButton(
                    onPressed: (myTimestamps.last.exitTimestamp == null)
                        ? () async {
                            final LibraryTimestamp lastTimestamp =
                                myTimestamps.last;
                            lastTimestamp.exitTimestamp = DateTime.now();
                            await timestampProvider
                                .saveTimestamp(lastTimestamp);
                          }
                        : null,
                    icon: const Icon(Icons.logout)),
            ],
          ),
        );
      },
    );
  }
}
