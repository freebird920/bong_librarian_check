// HomePage.dart

// pub packages
import 'package:bong_librarian_check/app/home/components/modal_additional_attend.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// providers
import 'package:bong_librarian_check/providers/provider_librarian.dart';

// Enums
import 'package:bong_librarian_check/enums/enum_list_view_librarians_segment.dart';

// Classes
import 'package:bong_librarian_check/classes/class_result.dart';

// Components
import 'package:bong_librarian_check/app/home/components/list_tile_librarian.dart';
import 'package:bong_librarian_check/components/comp_navbar.dart';

// helpers
import 'package:bong_librarian_check/helper/weekdayParser.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DateTime now = DateTime.now();
  ListViewLibrariansSegment selectedViewSegment =
      ListViewLibrariansSegment.attention;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final librarianProvider =
            Provider.of<ProviderLibrarian>(context, listen: false);
        if (!librarianProvider.isLoading && librarianProvider.data.isEmpty) {
          librarianProvider.loadLibrarians();
        }
        // 로딩 상태를 감지하는 리스너 추가
        librarianProvider.addListener(() {
          if (!librarianProvider.isLoading && librarianProvider.data.isEmpty) {
            // 로딩이 완료되고 데이터가 비어있을 때 다이얼로그 표시
            openAlertDialogNoLibrarians(context: context);
          }
        });

        // 만약 처음부터 로딩이 끝나있다면 바로 다이얼로그를 보여줌

        librarianProvider.removeListener(() {});
      },
    );
  }

  final Result<String> dayOfWeekString = weekdayParser(DateTime.now().weekday);

  @override
  Widget build(BuildContext context) {
    final librarianProvider = Provider.of<ProviderLibrarian>(context);
    final librarians = librarianProvider.data;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("도서부 출석 체크"),
        actions: [
          IconButton(
            icon: const Icon(Icons.addchart),
            onPressed: () {
              openAdditionalAttend(context: context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("오늘은 ${dayOfWeekString.data}요일 입니다."),
            ),
            SegmentedButton(
              segments: const <ButtonSegment<ListViewLibrariansSegment>>[
                ButtonSegment(
                  label: Text("즐근"),
                  value: ListViewLibrariansSegment.attention,
                ),
                ButtonSegment(
                  label: Text("퇴근"),
                  value: ListViewLibrariansSegment.exit,
                ),
              ],
              selected: <ListViewLibrariansSegment>{selectedViewSegment},
              onSelectionChanged: (Set<ListViewLibrariansSegment> value) {
                setState(() {
                  selectedViewSegment = value.first;
                });
              },
            ),
            Expanded(
              child: ListViewLibrarians(
                librarians: librarians,
                selectedViewSegment: selectedViewSegment,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CompNavbar(),
    );
  }
}

void openAlertDialogNoLibrarians({required BuildContext context}) {
  showDialog(
    context: context,
    builder: (context) {
      return const AlertDialogNoLibrarians();
    },
  );
}

class AlertDialogNoLibrarians extends StatelessWidget {
  const AlertDialogNoLibrarians({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("알림"),
      content: const Text("현재 도서부 사서가 없습니다. 사서를 추가해주세요."),
      actions: [
        TextButton(
          onPressed: () {
            GoRouter.of(context).go("/settings/set_librarians");
            Navigator.pop(context);
          },
          child: const Text("추가하러가겠읍니다."),
        ),
      ],
    );
  }
}
