import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/components/alert_dialog_year_picker.dart';
import 'package:bong_librarian_check/helper/student_id_validator.dart';
import 'package:bong_librarian_check/providers/provider_librarian.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void openAddLibrarian(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => const ModalAddLibrarian(),
  );
}

class ModalAddLibrarian extends StatefulWidget {
  const ModalAddLibrarian({super.key});

  @override
  State<ModalAddLibrarian> createState() => _ModalAddLibrarianState();
}

class _ModalAddLibrarianState extends State<ModalAddLibrarian> {
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
    final librarianProvider = Provider.of<ProviderLibrarian>(context);
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                autofocus: true,
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'no value!';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _enteranceYearController,
                decoration: const InputDecoration(labelText: "Enterance Year"),
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
                controller: _studentIdController,
                decoration: const InputDecoration(labelText: "Student Id"),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: studentIdValidator,
              ),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                  librarianProvider.loadLibrarians();
                  GoRouter.of(context).pop();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
