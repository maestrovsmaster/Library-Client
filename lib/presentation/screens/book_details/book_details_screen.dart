import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/presentation/block/book_details/book_details_bloc.dart';
import 'package:leeds_library/presentation/block/book_details/book_details_event.dart';
import 'package:leeds_library/presentation/block/book_details/book_details_state.dart';
import 'package:leeds_library/presentation/screens/book_details/widgets/description_widget.dart';

import 'widgets/availablity_widget.dart';
import 'widgets/book_details.dart';
import 'widgets/footer_widget.dart';

class BookDetailsScreen extends StatefulWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {

  @override
  void initState() {
    super.initState();
    context.read<BookDetailsBloc>().add(LoadBooksEvent(widget.book.id));
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookDetailsBloc, BookDetailsState>(
      builder: (context, state) {
        if (state is BookInitialState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is BookNotFoundState) {
          return const Center(child: Text("Книгу не знайдено"));
        }

        if (state is BookLoadedState) {
          final book = state.book;
          return Scaffold(
            appBar: AppBar(
              title: const Text("Про книгу"),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: BookAvailabilityWidget(book: book),
                )
              ],
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 56),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          BookDetails(book: book),
                          const SizedBox(height: 20),
                          DescriptionWidget(description: book.description),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FooterWidget(book: book),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink(); // fallback
      },
    );
  }
}
