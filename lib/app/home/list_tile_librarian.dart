import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/classes/class_library_timestamp.dart';
import 'package:bong_librarian_check/providers/provider_timestamp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListViewLibrarians extends StatelessWidget {
  const ListViewLibrarians({
    super.key,
    required this.filteredLibrarians,
  });
  final List<Librarian> filteredLibrarians;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: filteredLibrarians.length,
      itemBuilder: (context, index) {
        final thisLibrarian = filteredLibrarians[index];
        final timestampProvider =
            Provider.of<ProviderTimestamp>(context, listen: false);

        return FutureBuilder(
          future: timestampProvider.getTimestampsByDayLuuid(
              thisDay: DateTime.now(), librarianUuid: thisLibrarian.uuid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ListTile(title: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const ListTile(title: Text("Error"));
            }
            return ListTile(
              leading: Text(index.toString()),
              title: Text(
                  'name: ${thisLibrarian.name} timestampLengt: ${snapshot.data!.data!.length.toString()}'),
              subtitle: Text(thisLibrarian.studentId.toString()),
              trailing: const Text("data"),
            );
          },
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
