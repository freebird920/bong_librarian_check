import 'package:bong_librarian_check/components/alert_dialog_string_msg.dart';
import 'package:bong_librarian_check/providers/provider_librarian.dart';
import 'package:bong_librarian_check/services/asset_file_service.dart';
import 'package:bong_librarian_check/services/excel_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void openUploadExcel({
  required BuildContext context,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => const ModalUploadExcel(),
  );
}

class ModalUploadExcel extends StatelessWidget {
  const ModalUploadExcel({super.key});
  @override
  Widget build(BuildContext context) {
    ProviderLibrarian librarianProvider =
        Provider.of<ProviderLibrarian>(context, listen: false);
    return FractionallySizedBox(
      heightFactor: 0.9,
      widthFactor: 0.9,
      child: Column(
        children: [
          const Text("data"),
          Expanded(
              child: ListView(
            children: [
              ListViewUploadFile(librarianProvider: librarianProvider),
              ListTile(
                leading: const Icon(Icons.file_download),
                title: const Text("예시 파일 다운로드"),
                subtitle: const Text("엑셀파일 양식을 다운로드합니다. "),
                onTap: () {
                  final assetFileService = AssetFileService();
                  assetFileService.copyAssetToLocal(
                      assetPath: "assets/excels/librarian_form_example.xlsx",
                      fileName: "librarian_form_example.xlsx");
                  openAlertDialogStringMsg(
                      context: context, message: "다운로드 완료");
                },
              )
            ],
          )),
          IconButton(
            icon: const Icon(Icons.manage_history_outlined),
            onPressed: () async {
              final getLibrarians = await ExcelService().excelToJson();
              for (var element in getLibrarians) {
                print(element.name);
                librarianProvider.addLibrarian(element);
              }
            },
          )
        ],
      ),
    );
  }
}

class ListViewUploadFile extends StatefulWidget {
  const ListViewUploadFile({
    super.key,
    required this.librarianProvider,
  });

  final ProviderLibrarian librarianProvider;

  @override
  State<ListViewUploadFile> createState() => _ListViewUploadFileState();
}

class _ListViewUploadFileState extends State<ListViewUploadFile> {
  void _popContext() {
    // `mounted` 확인 후 Navigator 실행
    if (mounted) {
      Navigator.of(context).pop();
      openAlertDialogStringMsg(context: context, message: "업로드 완료");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.upload_file),
      title: const Text("Excel 파일 업로드"),
      subtitle: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("엑셀 파일을 업로드하여 데이터를 추가합니다."),
          Text("아래의 양식을 받아서 작성해주세요."),
        ],
      ),
      onTap: () async {
        final getLibrarians = await ExcelService().excelToJson();
        for (var element in getLibrarians) {
          await widget.librarianProvider.addLibrarian(element);
        } // mounted 확인
        _popContext();
      },
    );
  }
}
