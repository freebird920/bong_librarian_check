import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/classes/class_library_timestamp.dart';
import 'package:bong_librarian_check/enums/enum_list_view_librarians_segment.dart';
import 'package:bong_librarian_check/providers/provider_timestamp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  List<Librarian> _filteredLibrarins = [];

  @override
  Widget build(BuildContext context) {
    // filter librarians based on selected segment
    switch (widget.selectedViewSegment) {
      case ListViewLibrariansSegment.attention:
        _filteredLibrarins = widget.librarians
            .where(
              (e) => e.workDays!.contains(DateTime.now().weekday),
            )
            .toList();
        break;
      case ListViewLibrariansSegment.exit:
        break;
    }

    final ProviderTimestamp timestampProvider =
        Provider.of<ProviderTimestamp>(context);
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
          title: Text('name: ${thisLibrarian.name} timestampLengtH:}'),
          subtitle: Text(thisLibrarian.studentId.toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                  icon: const Icon(Icons.add)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.logout)),
            ],
          ),
        );
      },
    );
  }
}

class LibrarianTile extends StatelessWidget {
  const LibrarianTile({
    super.key,
    required this.thisLibrarain,
    required this.isAttended,
    required this.timestampProvider,
  });

  final Librarian thisLibrarain;
  final bool isAttended;
  final ProviderTimestamp timestampProvider;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(thisLibrarain.name),
      subtitle: Text("Student ID: ${thisLibrarain.studentId}"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: isAttended
                ? null
                : () {
                    timestampProvider.saveTimestamp(
                      LibraryTimestamp(
                        librarianUuid: thisLibrarain.uuid,
                        timestamp: DateTime.now(),
                      ),
                    );
                  },
          ),
          IconButton(
            onPressed: () async {
              final timestampUuid = timestampProvider
                  .getTodayTimeStampbyLibrarianUuid(thisLibrarain.uuid)
                  .data;
              if (timestampUuid == null) {
                throw Exception("timestampUuid is null");
              }

              final newTimestamp =
                  await timestampProvider.getTimestampByUuid(timestampUuid);

              if (newTimestamp.isSuccess) {
                final updatedTimestamp = newTimestamp.data!;
                updatedTimestamp.exitTimestamp = DateTime.now();
                await timestampProvider.updateTimestamp(
                  newTimestamp: updatedTimestamp,
                );
              }
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
    );
  }
}
