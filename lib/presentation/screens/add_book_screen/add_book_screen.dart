import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/core/utils/utils.dart';
import 'package:leeds_library/presentation/block/add_book/add_book_bloc.dart';
import 'package:leeds_library/presentation/block/add_book/add_book_event.dart';
import 'package:leeds_library/presentation/block/add_book/add_book_state.dart';
import 'package:leeds_library/presentation/widgets/barcode_scanner_dialog/barcode_scanner_dialog.dart';

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
  final _barcodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _imageFile;

  final _authorFocus = FocusNode();
  final _publisherFocus = FocusNode();
  final _genreFocus = FocusNode();
  final _barcodeFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  @override
  Widget build(BuildContext context) {

    final text = widget.barcode??"";
    final isBarcode = isNumeric(text);
    if(isBarcode) {
      _barcodeController.text = text;
    }else{
      _titleController.text = text;
    }

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
            return   SafeArea(
                child: SingleChildScrollView(
                child:  Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: "Назва книги"),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) => value!.isEmpty ? "Введіть назву" : null,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_authorFocus);
                      },
                    ),
                    TextFormField(
                      controller: _authorController,
                      decoration: InputDecoration(labelText: "Автор"),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) => value!.isEmpty ? "Введіть автора" : null,
                      focusNode: _authorFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_publisherFocus);
                      },
                    ),
                    TextFormField(
                      controller: _publisherController,
                      decoration: InputDecoration(labelText: "Видавець"),
                      textCapitalization: TextCapitalization.sentences,
                      focusNode: _publisherFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_genreFocus);
                      },
                    ),
                    TextFormField(
                      controller: _genreController,
                      decoration: InputDecoration(labelText: "Жанр"),
                      textCapitalization: TextCapitalization.sentences,
                      focusNode: _genreFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocus);
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: "Опис"),
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 5,
                      validator: (value) => value!.isEmpty ? "Введіть опис" : null,
                      focusNode: _descriptionFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_barcodeFocus);
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _barcodeController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      focusNode: _barcodeFocus,
                      decoration: InputDecoration(
                        labelText: "Штрихкод",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () async {
                            final result = await showDialog<String>(
                              context: context,
                              builder: (_) => const BarcodeScannerDialog(),
                            );

                            if (result != null) {
                              _barcodeController.text = result;
                             // context.read<BooksListBloc>().add(SearchQueryChangedEvent(result));
                            }
                          },
                        ),
                      ),
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
                            barcode: _barcodeController.text.trim(),
                            description: _descriptionController.text.trim(),
                            imageFile: _imageFile,
                          ));
                        }
                      },
                      child: Text("Зберегти"),
                    ),
                  ],
                ),
              ),
            )));


          },
        ),
      ),
    );
  }
}
