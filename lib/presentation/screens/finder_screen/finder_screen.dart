import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/core/theme/app_colors.dart';
import 'package:leeds_library/core/utils/utils.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/presentation/block/finder_bloc/finder_bloc.dart';
import 'package:leeds_library/presentation/block/finder_bloc/finder_event.dart';
import 'package:leeds_library/presentation/block/finder_bloc/finser_state.dart';
import 'package:leeds_library/presentation/navigation/app_router.dart';
import 'package:leeds_library/presentation/screens/books_list/book_item.dart';
import 'package:leeds_library/presentation/widgets/barcode_scanner_dialog/barcode_scanner_dialog.dart';
import 'package:leeds_library/presentation/widgets/book_for_loan_widget.dart';

class FinderScreen extends StatefulWidget {
  const FinderScreen({super.key});

  @override
  State<FinderScreen> createState() => _FinderScreenState();
}

class _FinderScreenState extends State<FinderScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController()
      ..addListener(() {
        setState(() {}); // для оновлення очищення
      });

    // Надіслати подію завантаження списку книг
    context.read<FinderBloc>().add(FinderLoadBooksEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Пошук книги")),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accentColor,
        foregroundColor: AppColors.white,
        onPressed: () async {
          final result = await showDialog<String>(
            context: context,
            builder: (_) => const BarcodeScannerDialog(),
          );

          if (result != null) {
            _searchController.text = result;
            context
                .read<FinderBloc>()
                .add(FinderSearchQueryChangedEvent(result));
          }
        },
        label: const Text('Сканувати'),
        icon: const Icon(Icons.camera_alt, size: 28),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: "Введіть назву...",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  context
                      .read<FinderBloc>()
                      .add(FinderSearchQueryChangedEvent(''));
                },
              )
                  : null,
            ),
            onChanged: (query) {
              context
                  .read<FinderBloc>()
                  .add(FinderSearchQueryChangedEvent(query));
            },
          ),
          const SizedBox(height: 26),


          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<FinderBloc, FinderState>(
              builder: (context, state) {
                if (state is FinderBooksListState) {
                  return StreamBuilder<List<Book>>(
                    stream: state.booksStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final books = snapshot.data!;
                      final searchText = _searchController.text.trim();
                      final isBarcode = isNumeric(searchText);

                      if (searchText.isEmpty && books.isEmpty) {
                        return const Center(
                          child: Text("Введіть назву книги або зіскануйте Штрихкод"),
                        );
                      }

                      if (books.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                isBarcode
                                    ? "Книги з таким ШК не знайдено. Спробуйте знайти за назвою, або додайте ШК до існуючої книги в розділі Books"
                                    : "Книги з такою назвою не знайдено. Додати нову книгу?",
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  context.push(AppRoutes.addBook, extra: searchText);
                                },
                                child: Text(isBarcode
                                    ? "Додати нову книгу зі ШК"
                                    : "Додати нову книгу"),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        separatorBuilder: (context, index) =>
                            Divider(height: 0.5, color: Colors.grey[300]),
                        itemCount: books.length,
                        itemBuilder: (context, index) => BookForLoanWidget(
                          book: books[index],
                          onBook: (book) {
                            context.push(AppRoutes.createLoan, extra: book);
                          },
                          onReturn: (book) {
                            context.read<FinderBloc>().add(ReturnBookEventEvent(book));
                          },
                        ),
                      );
                    },
                  );
                } else if (state is BooksErrorState) {
                  return Center(child: Text(state.message));
                } else if (state is SuccessReturnBookState) {
                  return const Center(child: Text("Книга повернена"));
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
