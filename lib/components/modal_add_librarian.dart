import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/services/file_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final _dayController = TextEditingController();
  final _studentIdController = TextEditingController();
  // 폼 제출 처리
  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // 유효성 검사가 통과되었을 때 폼 제출 로직 실행
      print('Form submitted');
      print('Name: ${_nameController.text}');

      final Librarian librarian = Librarian(
        name: _nameController.text,
        studentId: int.tryParse(_studentIdController.value.text) ?? 0,
        enteranceYear: 2024,
        day: 123,
      );
      print(librarian.toJsonString);
      // 폼을 초기화할 수도 있습니다.
      final fileService = FileService();
      fileService.writeLibrarians([librarian]);
      _formKey.currentState?.reset();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _formKey.currentState?.dispose();
    _nameController.dispose();
    _dayController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Form(
        child: SingleChildScrollView(
          child: Form(
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a number';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid decimal number';
                    }
                    if (double.parse(value) <= 10100) {
                      return 'Please enter a number greater than 10100';
                    }
                    if (double.parse(value) > 39999) {
                      return 'Please enter a number under 39999';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a number';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid decimal number';
                    }
                    if (double.parse(value) <= 10100) {
                      return 'Please enter a number greater than 10100';
                    }
                    if (double.parse(value) > 39999) {
                      return 'Please enter a number under 39999';
                    }
                    return null;
                  },
                ),
                const TextField(
                  decoration: InputDecoration(labelText: "Day"),
                ),
                const TextField(
                  decoration: InputDecoration(labelText: "Student ID"),
                ),
                const TextField(
                  decoration: InputDecoration(labelText: "Description"),
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
