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
    builder: (context) => ModalAddLibrarian(librarian: librarian),
  );
}

class ModalAddLibrarian extends StatefulWidget {
  final Librarian librarian;
  const ModalAddLibrarian({
    required this.librarian,
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
  void _editLibrarian(String uuid) {
    final librarinaProvider =
        Provider.of<ProviderLibrarian>(context, listen: false);

    final Librarian librarian = Librarian(
      uuid: uuid,
      name: _nameController.text,
      studentId: _studentIdController.value.text,
      enteranceYear: 2034,
    );
    librarinaProvider.updateLibrarian(librarian);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("edit"),
      ),
    );
    // FORM 초기화
    _formKey.currentState?.reset();
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.librarian.name;
    _studentIdController.text = widget.librarian.studentId.toString();
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
              const Text("Librarin Edit"),
              Text(widget.librarian.uuid),
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
                  // _submitForm();
                  _editLibrarian(widget.librarian.uuid);
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
