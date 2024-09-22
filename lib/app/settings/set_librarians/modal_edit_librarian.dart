import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/helper/student_id_validator.dart';
import 'package:bong_librarian_check/providers/provider_librarian.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void openEditLibrarian({
  required BuildContext context,
  required Librarian librarian,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => const ModalAddLibrarian(),
  );
}

class ModalAddLibrarian extends StatefulWidget {
  const ModalAddLibrarian({
    super.key,
  });

  @override
  State<ModalAddLibrarian> createState() => _ModalAddLibrarianState();
}

class _ModalAddLibrarianState extends State<ModalAddLibrarian> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // input values
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();

  // 폼 제출 처리
  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // 유효성 검사가 통과되었을 때 폼 제출 로직 실행
      final librarinaProvider =
          Provider.of<ProviderLibrarian>(context, listen: false);

      final Librarian librarian = Librarian(
        name: _nameController.text,
        studentId: int.tryParse(_studentIdController.value.text) ?? 0,
        enteranceYear: 2034,
        dayOfWeek: 2,
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
  void dispose() {
    _formKey.currentState?.dispose();
    _nameController.dispose();
    _studentIdController.dispose();

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
