// import from flutter
import 'package:bong_librarian_check/app/settings/set_librarians/components/alert_dialog_set_day_of_week.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import from lib
import 'package:bong_librarian_check/helper/day_of_week_parser.dart';
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
    final dayOfWeek = dayOfWeekParser(librarian.dayOfWeek);

    return ListTile(
      key: ValueKey(librarian.uuid),
      leading: Text((index + 1).toString()),
      title: Text(
          "[${librarian.enteranceYear}] ${librarian.studentId.toString()} /  ${librarian.name}"),
      subtitle: OutlinedButton(
        onPressed: () {
          openSetDayOfWeekDialog(context: context, librarian: librarian);
        },
        child: Text("${dayOfWeek.isSuccess ? dayOfWeek.data : "설정하세요"} "),
      ),
      trailing: LibrarianPopupMenu(librarian: librarian),
    );
  }
}
