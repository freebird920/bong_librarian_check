// import from flutter
import 'package:bong_librarian_check/app/settings/set_librarians/components/alert_dialog_set_workday.dart';
import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/helper/weekdayParser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import from lib
import 'package:bong_librarian_check/app/settings/set_librarians/components/popup_menu_librarian.dart';

/// # LibrarianListTile
/// - Librarian 객체를 받아서 ListTile로 표현
/// - index: 순서
/// - librarian: Librarian 객체
/// - ListTile: 순서, 이름, 학번, PopupMenuButton으로 구성
class LibrarianListTile extends StatelessWidget {
  final int index;
  final Librarian librarian;
  const LibrarianListTile({
    super.key,
    required this.index,
    required this.librarian,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 3,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      hoverColor: Colors.grey[200],
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
        child: Text(
          librarian.workDays == null
              ? "설정되지 않음"
              : librarian.workDays!.isNotEmpty
                  ? librarian.workDays!
                      .map(
                        (e) => weekdayParser(e).data,
                      )
                      .join(", ")
                  : "설정되지 않음",
          style: const TextStyle(
            fontFamily: "NotoSansKR",
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
      trailing: LibrarianPopupMenu(librarian: librarian),
    );
  }
}
