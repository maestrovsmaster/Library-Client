import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/presentation/block/add_book/add_book_bloc.dart';
import 'package:leeds_library/presentation/block/add_book/add_book_event.dart';
import 'package:leeds_library/presentation/block/add_book/add_book_state.dart';

class AddBookScreen extends StatefulWidget {
  final String? barcode;
  const AddBookScreen({Key? key, required this.barcode}) : super(key: key);

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _publisherController = TextEditingController();
  final _genreController = TextEditingController();
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddBookBloc>(),
      child: Scaffold(
        appBar: AppBar(title: Text("Додати книгу")),
        body: BlocConsumer<AddBookBloc, AddBookState>(
          listener: (context, state) {
            if (state is AddBookSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Книга додана!")));
              Navigator.pop(context, true);
            } else if (state is AddBookFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Помилка: ${state.error}")));
            } else if (state is AddBookImagePicked) {
              setState(() => _imageFile = state.imageFile);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: "Назва книги"),
                      validator: (value) => value!.isEmpty ? "Введіть назву" : null,
                    ),
                    TextFormField(
                      controller: _authorController,
                      decoration: InputDecoration(labelText: "Автор"),
                      validator: (value) => value!.isEmpty ? "Введіть автора" : null,
                    ),
                    TextFormField(
                      controller: _publisherController,
                      decoration: InputDecoration(labelText: "Видавець"),
                    ),
                    TextFormField(
                      controller: _genreController,
                      decoration: InputDecoration(labelText: "Жанр"),
                    ),
                    SizedBox(height: 20),

                    _imageFile != null
                        ? Image.file(_imageFile!, height: 150)
                        : Text("Фото не вибране"),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.camera),
                          onPressed: () => context.read<AddBookBloc>().add(PickImageEvent(ImageSource.camera)),
                        ),
                        IconButton(
                          icon: Icon(Icons.image),
                          onPressed: () => context.read<AddBookBloc>().add(PickImageEvent(ImageSource.gallery)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    state is AddBookLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AddBookBloc>().add(SubmitBookEvent(
                            title: _titleController.text.trim(),
                            author: _authorController.text.trim(),
                            genre: _genreController.text.trim(),
                            publisher: _publisherController.text.trim(),
                            barcode: widget.barcode??"",
                            imageFile: _imageFile,
                          ));
                        }
                      },
                      child: Text("Зберегти"),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
