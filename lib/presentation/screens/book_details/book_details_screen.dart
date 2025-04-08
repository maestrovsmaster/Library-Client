import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/presentation/block/book_details/book_details_bloc.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Про книгу"),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: BookAvailabilityWidget(book: widget.book),
        )
      ],
      ),
      body: SafeArea(

       child:  Stack(
          children: [

        Padding(padding: EdgeInsets.only(bottom: 56), child:
         SingleChildScrollView( child:
         Column(children: [
           BookDetails(book: widget.book),
           SizedBox(height: 20),
            DescriptionWidget(description: widget.book.description),


         ],)
         )),

           /* SizedBox(height: 20),
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                child: DescriptionWidget(description: widget.book.description),
              ),
            ),*/
            Align(alignment: Alignment.bottomCenter, child:
            FooterWidget(book: widget.book)),
          ],
        ),
      ),
    );
  }
}
