
import 'package:leeds_library/data/models/book.dart';

class BooksSearchRepository {
  /// Шукає книги у кешованому списку за назвою, автором або штрихкодом
  List<Book> searchBooks(List<Book> books, String query) {
    if (query.isEmpty) return books;
    final lowerQuery = query.toLowerCase().trim();

    return books.where((book) {
      return book.title.toLowerCase().contains(lowerQuery) ||
          book.author.toLowerCase().contains(lowerQuery) ||
          book.barcode.toLowerCase() == lowerQuery;
    }).toList();
  }
}
