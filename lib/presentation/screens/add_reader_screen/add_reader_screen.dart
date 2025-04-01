import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/presentation/block/add_reader/add_reader_bloc.dart';
import 'package:leeds_library/presentation/block/add_reader/add_reader_event.dart';
import 'package:leeds_library/presentation/block/add_reader/add_reader_state.dart';

class AddReaderScreen extends StatefulWidget {

  final String? name;

  const AddReaderScreen({super.key, this.name});

  @override
  State<AddReaderScreen> createState() => _AddReaderScreenState();
}

class _AddReaderScreenState extends State<AddReaderScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _phoneAltController = TextEditingController();

  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _phoneAltFocus = FocusNode();

  @override
  Widget build(BuildContext context) {

    _nameController.text = widget.name??"";

    return BlocProvider(
      create: (_) => sl<AddReaderBloc>(),
      child: Scaffold(
        appBar: AppBar(title: Text("Додати читача")),
        body: BlocConsumer<AddReaderBloc, AddReaderState>(
          listener: (context, state) {
            if (state is AddReaderSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Читача додано!")));
              Navigator.pop(context, state.reader);
            } else if (state is AddReaderFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Помилка: ${state.error}")));
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: "Ім’я та прізвище"),
                        textCapitalization: TextCapitalization.words,
                        validator: (v) => v!.isEmpty ? "Введіть ім’я" : null,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_emailFocus);
                        },
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: "Email"),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => v!.contains("@") ? null : "Невалідний email",
                        focusNode: _emailFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_phoneFocus);
                        },

                      ),

                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(labelText: "Телефон"),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (v) =>
                        v!.length < 8 ? "Невалідний номер" : null,
                        focusNode: _phoneFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_phoneAltFocus);
                        },
                      ),
                      TextFormField(
                        controller: _phoneAltController,
                        decoration: InputDecoration(labelText: "Альтернативний телефон"),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        focusNode: _phoneAltFocus,
                      ),
                      const SizedBox(height: 24),
                      state is AddReaderLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AddReaderBloc>().add(
                              SubmitReaderEvent(
                                email: _emailController.text.trim(),
                                name: _nameController.text.trim(),
                                phoneNumber: _phoneController.text.trim(),
                                phoneNumberAlt:
                                _phoneAltController.text.trim(),
                              ),
                            );
                          }
                        },
                        child: Text("Зберегти"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
