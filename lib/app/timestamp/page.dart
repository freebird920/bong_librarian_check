import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/components/comp_navbar.dart';
import 'package:bong_librarian_check/providers/provider_librarian.dart';
import 'package:bong_librarian_check/providers/provider_timestamp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimestampPage extends StatefulWidget {
  const TimestampPage({super.key});

  @override
  State<TimestampPage> createState() => _TimestampPageState();
}

class _TimestampPageState extends State<TimestampPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProviderTimestamp>(context, listen: false).loadTimestamps();
    });
  }

  @override
  Widget build(BuildContext context) {
    final timestampProvider = Provider.of<ProviderTimestamp>(context);
    final librarianProvider = Provider.of<ProviderLibrarian>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("data"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: timestampProvider.data.length,
          itemBuilder: (context, index) {
            final timestamp = timestampProvider.data[index];
            final librarian =
                librarianProvider.getLibrarian(timestamp.librarianUuid);
            return ListTile(
              leading: Text('${index + 1}'),
              title:
                  Text(librarian.isSuccess ? librarian.data!.name : 'no user'),
              subtitle: Text("Timestamp: ${timestamp.timestamp}"),
            );
          },
        ),
      ),
      bottomNavigationBar: const CompNavbar(),
    );
  }
}
