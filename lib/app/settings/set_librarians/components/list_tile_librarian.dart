// import from flutter
import 'package:bong_librarian_check/app/settings/set_librarians/components/alert_dialog_set_workday.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import from lib
import 'package:bong_librarian_check/providers/provider_librarian.dart';
import 'package:bong_librarian_check/app/settings/set_librarians/components/popup_menu_librarian.dart';

/// # LibrarianListTile
/// - Librarian 객체를 받아서 ListTile로 표현
/// - index: 순서
/// - librarian: Librarian 객체
/// - ListTile: 순서, 이름, 학번, PopupMenuButton으로 구성
class LibrarianListTile extends StatelessWidget {
  final int index;
  const LibrarianListTile({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final librarianProvider = Provider.of<ProviderLibrarian>(context);
    final librarian = librarianProvider.data[index];

    return ListTile(
      key: ValueKey(librarian.uuid),
      leading: Text((index + 1).toString()),
      title: Text(
        "[${librarian.enteranceYear}] ${librarian.studentId.toString()} /  ${librarian.name}",
        style: const TextStyle(
          fontFamily: "IBMPlexMono",
          textBaseline: TextBaseline.ideographic,
        ),
      ),
      subtitle: OutlinedButton(
        onPressed: () {
          openSetDayOfWeekDialog(context: context, librarian: librarian);
        },
        child: const Text(
          "${"설정하세요"} ",
          style: TextStyle(
            fontFamily: "NotoSansKR",
            fontWeight: FontWeight.w500,
            fontSize: 14,
            // decoration: TextDecoration.lineThrough,
          ),
        ),
      ),
      trailing: LibrarianPopupMenu(librarian: librarian),
    );
  }
}
