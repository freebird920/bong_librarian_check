import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/components/alert_dialog_error_go_home.dart';
import 'package:bong_librarian_check/components/alert_dialog_year_picker.dart';
import 'package:bong_librarian_check/enums/enum_set_librarian_view.dart';
import 'package:bong_librarian_check/helper/student_id_validator.dart';
import 'package:bong_librarian_check/providers/provider_librarian.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void openSetLibrarian({
  required BuildContext context,
  required ModalSetLibrarianType type,
  Librarian? librarian,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      if (type == ModalSetLibrarianType.edit && librarian == null) {
        return const AlertDialogErrorGoHome();
      }
      return ModalSetLibrarian(
        type: type,
      );
    },
  );
}

class ModalSetLibrarian extends StatefulWidget {
  final ModalSetLibrarianType type;
  final Librarian? librarian;
  const ModalSetLibrarian({
    super.key,
    required this.type,
    this.librarian,
  });

  @override
  State<ModalSetLibrarian> createState() => _ModalSetLibrarianState();
}

class _ModalSetLibrarianState extends State<ModalSetLibrarian> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // input values
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _enteranceYearController = TextEditingController();
  // 폼 제출 처리
  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // 유효성 검사가 통과되었을 때 폼 제출 로직 실행
      final librarinaProvider =
          Provider.of<ProviderLibrarian>(context, listen: false);

      final Librarian librarian = Librarian(
        name: _nameController.text,
        studentId: _studentIdController.value.text,
        enteranceYear: int.tryParse(_enteranceYearController.text) ?? 0,
      );
      librarinaProvider.addLibrarian(librarian);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("add"),
        ),
      );
      // FORM 초기화
      _formKey.currentState?.reset();
    }
  }

  @override
  void initState() {
    super.initState();
    _enteranceYearController.text = DateTime.now().year.toString();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _nameController.dispose();
    _studentIdController.dispose();
    _enteranceYearController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final librarianProvider = Provider.of<ProviderLibrarian>(
      context,
    );
    return FractionallySizedBox(
      heightFactor: 0.9,
      widthFactor: 0.9,
      child: SingleChildScrollView(
        child: Center(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (widget.type == ModalSetLibrarianType.add)
                    const Text("이용자 추가"),
                  if (widget.type == ModalSetLibrarianType.edit)
                    const Text("Edit Librarian"),
                  const SizedBox(height: 20),
                  const Divider(),
                  TextFormField(
                    controller: _enteranceYearController,
                    decoration: const InputDecoration(labelText: "입학년도"),
                    onTap: () async {
                      int? result = await showYearPicker(
                          context: context, now: DateTime.now());
                      if (result != null) {
                        _enteranceYearController.text = result.toString();
                      }
                    },
                    readOnly: true,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  TextFormField(
                    autofocus: true,
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "이름"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'no value!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _studentIdController,
                    decoration: const InputDecoration(labelText: "학번"),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: studentIdValidator,
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context)
                                      .colorScheme
                                      .inversePrimary)),
                          onPressed: () {
                            GoRouter.of(context).pop();
                          },
                          child: const Text("취소")),
                      ElevatedButton(
                        onPressed: () {
                          _submitForm();
                          librarianProvider.loadLibrarians();
                          GoRouter.of(context).pop();
                        },
                        child: const Text('확인'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
