import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/data/models/reader.dart';
import 'package:leeds_library/presentation/block/create_loan/create_loan_bloc.dart';
import 'package:leeds_library/presentation/block/create_loan/create_loan_event.dart';
import 'package:leeds_library/presentation/block/create_loan/create_loan_state.dart';
import 'package:leeds_library/presentation/navigation/app_router.dart';
import 'package:leeds_library/presentation/screens/add_reader_screen/add_reader_screen.dart';
import 'package:leeds_library/presentation/screens/books_list/book_item.dart';
import 'package:leeds_library/presentation/widgets/book_widget.dart';
import 'package:leeds_library/presentation/widgets/reader_widget.dart';

class CreateLoanScreen extends StatelessWidget {
  final Book book;

  CreateLoanScreen({Key? key, required this.book}) : super(key: key);

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CreateLoanBloc>(),
      child: Scaffold(
        appBar: AppBar(title: Text("Оформити видачу")),
        body: BlocConsumer<CreateLoanBloc, CreateLoanState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookWidget(book: book, onTap: (_) {}),
                  const SizedBox(height: 24),
                  if(state is CreateLoanInitial|| state is CreateLoanReadersFound || state is CreateLoanLoading)
                  StatefulBuilder(
                    builder: (context, setState) {
                      _searchController.addListener(() {
                        setState(() {});
                      });

                      return TextField(
                        controller: _searchController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                            hintText: "Пошук читача за іменем",
                            prefixIcon:  Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )),
                        onChanged: (query) {
                          context
                              .read<CreateLoanBloc>()
                              .add(SearchReaderEvent(query));
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  if (state is CreateLoanLoading)
                    Center(child: CircularProgressIndicator()),
                  if (state is CreateLoanReadersFound &&
                      state.readers.isNotEmpty)
                    Expanded(
                      child: ListView.separated(
                        itemCount: state.readers.length,
                        separatorBuilder: (_, __) => Divider(),
                        itemBuilder: (_, index) {
                          final reader = state.readers[index];
                          return ReaderWidget(
                            reader: reader,
                            onShowSelectButton: true,
                            onSelect: (reader) {
                              print("Вибрано: ${reader.name}");
                              //select reader block event
                              context
                                  .read<CreateLoanBloc>()
                                  .add(SelectReaderEvent(reader));
                            },
                          );
                        },
                      ),
                    ),
                  if (state is CreateLoanReadersFound && state.readers.isEmpty)
                    Column(
                      children: [
                        Text("Читача не знайдено"),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () async {

                            final result = await context.push<Reader?>(
                              AppRoutes.addReader,
                              extra: _searchController.text,
                            );
                            if(result != null){
                              Reader newReader = result;
                              print("============newReader = $newReader");
                              final readerName = newReader.name;
                              _searchController.text = readerName;
                              context
                                  .read<CreateLoanBloc>()
                                  .add(SearchReaderEvent(readerName));
                            }
                          },
                          child: Text("Додати нового читача"),
                        )
                      ],
                    ),
                  if(state is SelectReaderState )
                    Column(children: [
                      ReaderWidget(
                        reader: state.reader,
                        onShowSelectButton: false,
                        onSelect: (reader) {
                          print("Вибрано: ${reader.name}");
                        },
                      ),

                      SizedBox(height: 12),

                      ElevatedButton(
                        onPressed: () async {
                        //call block event create Loan
                          context.read<CreateLoanBloc>().add(AddLoanEvent(book, state.reader));
                        },
                        child: Text("Забронювати"),
                      )


                    ],),

                  if(state is CreateLoanFailure)
                    Text(state.error),

                  if(state is CreateLoanSuccess)
                    Column(children: [
                      Text("Видачу заброньовано", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () async {
                          //Close screen
                          context.pop();
                        },
                        child: Text("Закрити"),
                      )

                    ],)


                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
