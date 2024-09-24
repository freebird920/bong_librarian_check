import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/classes/class_library_timestamp.dart';
import 'package:bong_librarian_check/providers/provider_timestamp.dart';
import 'package:flutter/material.dart';

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
