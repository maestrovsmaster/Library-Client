import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/data/net/result.dart';
import 'package:rxdart/rxdart.dart';

class BooksRepository{
  final Dio _dio;
  final FirebaseFirestore firestore;
  final Box<Book> bookBox;
  final String postfix;

  static const String collectionName = "books";
  String collectionPath = collectionName;

  final BehaviorSubject<List<Book>> _booksController =
  BehaviorSubject.seeded([]);
  Stream<List<Book>> get booksStream => _booksController.stream;

  final List<String> catetories = [];

  BooksRepository(this._dio, this.firestore, this.bookBox, {this.postfix = ''}){

    collectionPath = postfix.isEmpty?
    collectionName:
    "$collectionName-$postfix";

    _loadCachedBooks();
    _listenToFirestore();
  }


  Book? _findBookById(List<Book> books, String id) {
    try {
      return books.firstWhere((book) => book.id == id);
    } catch (_) {
      return null;
    }
  }

  Stream<Book?> getBookStreamById(String id) {
    return booksStream.map((books) => _findBookById(books, id)).distinct();
  }


  void _loadCachedBooks() {
    if (bookBox.isNotEmpty) {
      _booksController.add(bookBox.values.toList());
    }
  }

  void _listenToFirestore() {


    firestore.collection(collectionPath).snapshots().listen((snapshot) {
      if (snapshot.metadata.isFromCache &&
          !snapshot.metadata.hasPendingWrites) {
        return;
      }
      bool hasChanges = false;
      var books = [..._booksController.value];

      for (var change in snapshot.docChanges) {
        var book = Book.fromFirestore(change.doc);

        final category = book.genre;
        if (!catetories.contains(category)) {
          catetories.add(category);
        }

        if (change.type == DocumentChangeType.added) {
          if (!books.any((b) => b.id == book.id)) {
            books.add(book);
            hasChanges = true;
          }
        } else if (change.type == DocumentChangeType.removed) {
          books.removeWhere((b) => b.id == book.id);
          hasChanges = true;
        } else if (change.type == DocumentChangeType.modified) {
          var index = books.indexWhere((b) => b.id == book.id);
          print("DocumentChangeType.modified = $index");
          if (index != -1 &&
              (books[index].barcode != book.barcode ||
                  books[index].isAvailable != book.isAvailable ||
                  books[index].averageRating != book.averageRating ||
                  books[index].reviewsCount != book.reviewsCount
              )) {
            books[index] = book;
            hasChanges = true;
          }
        }
      }



      if (hasChanges) {
        _booksController.add(books);
        _cacheBooks(books);
      }
    });
  }

  void _cacheBooks(List<Book> books) async {
    await bookBox.clear();
    await bookBox.addAll(books);
  }






  Future<Result<Book?, String>> getBookByBarcode(String barcode) async {
    try {
      final response = await _dio.get(
        '/books-getBook',
        queryParameters: {'barcode': barcode},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print("getBookByBarcode response = ${response.data}");

      if (response.data == null) {
        return Result.notFound(); // Тепер це не помилка, а відсутність книжки
      }

      return Result.success(Book.fromJson(response.data));
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        if (statusCode == 403) {
          return Result.failure("Permission denied");
        } else if (statusCode! >= 500) {
          return Result.failure("Server error: ${e.response!.statusMessage}");
        }
      }
      return Result.failure("Network error: ${e.message}");
    } catch (e) {
      return Result.failure("Unexpected error: $e");
    }
  }


  /**
   * Create a new book.
   */
  Future<Result<Book?, String>> createBook(Book book) async {
    try {
      final response = await _dio.post(
        '/books-createBook',
        data: book.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print("createBook response = ${response.data}");

      if (response.statusCode == 201 && response.data != null) {
        return Result.success(Book.fromJson(response.data));
      } else {
        return Result.failure("Server returned an error: ${response.statusCode}");
      }
    }  on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        return Result.failure("Access denied: insufficient permissions.");
      } else {
        return Result.failure("Network error: ${e.message}");
      }
    } catch (e) {
      return Result.failure("Unexpected error: $e");
    }
  }

  Future<Result<Book?, String>> updateBook(Book book) async {
    try {
      final response = await _dio.put(
        '/books-editBook',
        data: book.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print("updateBook response = ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        return Result.success(Book.fromJson(response.data));
      } else {
        return Result.failure("Server returned an error: ${response.statusCode}");
      }
    }  on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        return Result.failure("Access denied: insufficient permissions.");
      } else {
        return Result.failure("Network error: ${e.message}");
      }
    } catch (e) {
      return Result.failure("Unexpected error: $e");
    }
  }

  Future<Result<Book?, String>> updateBookBarcode(String bookId, String barcode) async {
    try {
      final response = await _dio.put(
        '/books-updateBookBarcode',
        data: {
          'id': bookId,
          'barcode': barcode,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print("updateBook response = ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        return Result.success(Book.fromJson(response.data));
      } else {
        return Result.failure("Server returned an error: ${response.statusCode}");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        return Result.failure("Access denied: insufficient permissions.");
      } else {
        return Result.failure("Network error: ${e.message}");
      }
    } catch (e) {
      return Result.failure("Unexpected error: $e");
    }
  }

}