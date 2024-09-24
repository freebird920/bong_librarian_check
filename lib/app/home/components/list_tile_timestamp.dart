import 'package:bong_librarian_check/classes/class_library_timestamp.dart';
import 'package:bong_librarian_check/providers/provider_librarian.dart';
import 'package:flutter/material.dart';

class ListTileTimestamp extends StatelessWidget {
  final LibraryTimestamp thisTimestamp;
  const ListTileTimestamp({
    super.key,
    required this.thisTimestamp,
  });

  @override
  Widget build(BuildContext context) {
    ProviderLibrarian librarianProvider = ProviderLibrarian();
    final librarian =
        librarianProvider.getLibrarian(thisTimestamp.librarianUuid);

    return ListTile(
      title: Text((librarian.isSuccess && !librarian.isNull)
          ? librarian.data!.name
          : "Unknown"),
      subtitle: Text(thisTimestamp.timestamp.toIso8601String()),
    );
  }
}
