import 'package:bong_librarian_check/app/settings/set_librarians/components/list_tile_librarian.dart';
import 'package:bong_librarian_check/app/settings/set_librarians/components/modal_upload_excel.dart';
import 'package:bong_librarian_check/components/comp_navbar.dart';
import 'package:bong_librarian_check/components/modal_set_librarian.dart';
import 'package:bong_librarian_check/enums/enum_set_librarian_view.dart';
import 'package:bong_librarian_check/providers/provider_librarian.dart';
import 'package:bong_librarian_check/services/excel_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetLibrarinasPage extends StatefulWidget {
  const SetLibrarinasPage({super.key});

  @override
  State<SetLibrarinasPage> createState() => _SetLibrarinasPageState();
}

class _SetLibrarinasPageState extends State<SetLibrarinasPage> {
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final librarianProvider =
        Provider.of<ProviderLibrarian>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Librarians"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              librarianProvider.loadLibrarians();
            },
          ),
          IconButton(
            onPressed: () => ExcelService().jsonToExcel(librarianProvider.data),
            icon: const Icon(Icons.download),
          ),
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () => openUploadExcel(context: context),
          ),
          IconButton(
            onPressed: () => openSetLibrarian(
                context: context, type: ModalSetLibrarianType.add),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      bottomNavigationBar: const CompNavbar(),
      body: Center(
        child: Consumer<ProviderLibrarian>(
          builder: (context, provider, child) {
            return ListView.builder(
              controller: _scrollController, // 여기 추가
              itemCount: provider.data.length,
              itemBuilder: (context, index) {
                return LibrarianListTile(
                    index: index, librarian: provider.data[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
