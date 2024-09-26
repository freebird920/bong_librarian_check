import 'dart:io';

import 'package:bong_librarian_check/components/alert_dialog_string_msg.dart';
import 'package:bong_librarian_check/providers/provider_librarian.dart';
import 'package:bong_librarian_check/services/asset_file_service.dart';
import 'package:bong_librarian_check/services/excel_service.dart';
import 'package:bong_librarian_check/services/file_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path_package;

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

class ModalUploadExcel extends StatefulWidget {
  const ModalUploadExcel({super.key});

  @override
  State<ModalUploadExcel> createState() => _ModalUploadExcelState();
}

class _ModalUploadExcelState extends State<ModalUploadExcel> {
  @override
  Widget build(BuildContext context) {
    ProviderLibrarian librarianProvider =
        Provider.of<ProviderLibrarian>(context, listen: false);

    openAlertDialog({
      required String msg,
      String? mypath,
    }) {
      openAlertDialogStringMsg(
        context: context,
        message: msg,
        actions: mypath != null && Platform.isWindows
            ? [
                TextButton(
                  onPressed: () async {
                    FileService fileService = FileService();
                    final path = await fileService.localPath;
                    if (path.isError || path.isNull) {
                      throw path.error ?? Exception("Path is null");
                    }
                    await Process.run(
                        'explorer', [path_package.dirname(mypath)]);
                  },
                  child: const Text("폴더 열기"),
                ),
                const TextButtonCancel(),
              ]
            : null,
      );
    }

    return FractionallySizedBox(
      heightFactor: 0.9,
      widthFactor: 0.9,
      child: Column(
        children: [
          const Text("excel 파일로 추가",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          Expanded(
              child: ListView(
            children: [
              ListViewUploadFile(librarianProvider: librarianProvider),
              ListTile(
                leading: const Icon(Icons.file_download),
                title: const Text("예시 파일 다운로드"),
                subtitle: const Text("엑셀파일 양식을 다운로드합니다."),
                onTap: () async {
                  final assetFileService = AssetFileService();
                  final saveResult = await assetFileService.copyAssetToLocal(
                    assetPath: "assets/excels/librarian_form_example.xlsx",
                    fileName: "librarian_form_example",
                    fileExtention: "xlsx",
                  );

                  // 메시지 결정
                  String msg = "Failed to download example file";
                  if (saveResult.isError) {
                    msg = saveResult.error.toString();
                  } else {
                    msg = '${saveResult.getSuccessData}경로에 파일을 저장하였습니다.';
                  }

                  // `mounted` 확인 후 `context` 사용
                  if (mounted) {
                    openAlertDialog(
                      msg: msg,
                      mypath: saveResult.isSuccess
                          ? saveResult.getSuccessData
                          : null,
                    );
                  }
                },
              )
            ],
          )),
          IconButton(
            icon: const Icon(Icons.manage_history_outlined),
            onPressed: () async {
              final getLibrarians = await ExcelService().excelToJson();
              for (var element in getLibrarians) {
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
