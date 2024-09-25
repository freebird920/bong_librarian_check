import 'package:bong_librarian_check/services/excel_service.dart';
import 'package:flutter/material.dart';

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
    return FractionallySizedBox(
      heightFactor: 0.9,
      widthFactor: 0.9,
      child: Column(
        children: [
          const Text("data"),
          IconButton(
            icon: const Icon(Icons.manage_history_outlined),
            onPressed: () async {
              await ExcelService().createAndSaveExcelFile();
            },
          )
        ],
      ),
    );
  }
}
