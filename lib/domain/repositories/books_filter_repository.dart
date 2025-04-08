
import 'package:leeds_library/data/models/book.dart';

import 'books_repository.dart';

class BooksFilterRepository {
  final BooksRepository booksRepository;

  BooksFilterRepository(this.booksRepository);

  // Повертає книги без barcode
  Future<List<Book>> getBooksWithoutBarcode() async {
    //var books = await booksRepository.getBooks();
    return [];//books.where((book) => book.barcode == null).toList();
  }

  // Пошук книг за назвою або автором (ЛОКАЛЬНО, без Firestore)
  Future<List<Book>> searchBooks(String query) async {
    var books = []; //await booksRepository.getBooks();
    return []; //books.where((book) =>
    //book.title.toLowerCase().contains(query.toLowerCase()) ||
       // book.author.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
