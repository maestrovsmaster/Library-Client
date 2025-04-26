import 'dart:convert';

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
  final String booksPostfix;

  static const String collectionName = "books";
  String collectionPath = collectionName;

  final BehaviorSubject<List<Book>> _booksController =
  BehaviorSubject.seeded([]);
  Stream<List<Book>> get booksStream => _booksController.stream;

  final List<String> catetories = [];

  BooksRepository(this._dio, this.firestore, this.bookBox, {this.postfix = '' , this.booksPostfix = ''}){

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


  bool _firstRefreshDone = false;

  void _listenToFirestore() {
    final bookCollectionPath = booksPostfix.isEmpty
        ? collectionName
        : "$collectionName-$booksPostfix";

    print("BooksRepository collectionPath = $bookCollectionPath");

    firestore.collection(bookCollectionPath).snapshots().listen((snapshot) {
      print("BooksRepository listen");
      if (snapshot.metadata.isFromCache && !_firstRefreshDone) {
        print("BooksRepository return");
        return;
      }

      if (!snapshot.metadata.isFromCache) {
        print("BooksRepository cache");
        _firstRefreshDone = true;
      }

      final books = snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
      print("BooksRepository books $books");
      for (var book in books) {
        if (!catetories.contains(book.genre)) {
          catetories.add(book.genre);
        }
      }

      print("BooksRepository catetories $catetories");

      _booksController.add(books);
      _cacheBooks(books);
    });
  }


  void _cacheBooks(List<Book> books) async {
    await bookBox.clear();
    await bookBox.addAll(books);
  }


  Stream<List<String>> listenToReadingPlans(String userId) {
    final plans = "readingPlans";
    final collectionPath = postfix.isEmpty?
    plans:
    "$plans-$postfix";
    return firestore
        .collection(collectionPath)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => doc['bookId'] as String).toList());
  }

  Stream<List<Book>> myReadingPlanBooksStream(String userId) {
    return Rx.combineLatest2<List<Book>, List<String>, List<Book>>(
      booksStream,
      listenToReadingPlans(userId),
          (books, readingPlanIds) {
        return books
            .where((book) => readingPlanIds.contains(book.id))
            .toList();
      },
    );
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


  /**
   * Create a new ReadingPlan.
   */
  Future<Result<void, String>> createReadPlan(String bookId, String userId) async {
    try {
      final response = await _dio.post(
        '/readingPlans-createReadingPlan',
        data: {
          'bookId': bookId,
          'userId': userId,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print("createReadPlan response = ${response.data}");

      if (response.statusCode == 201 && response.data != null) {
        return Result.success(null);
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

  Future<Result<void, String>> deleteReadingPlan(String bookId, String userId) async {
    try {
      final response = await _dio.delete(
        '/readingPlans-deleteReadingPlan',
        data: {
          'bookId':bookId,
          'userId': userId},
      );

      if (response.statusCode == 200) {
        return Result.success(null);
      } else {
        return Result.failure("Server returned error: ${response.statusCode}");
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

  /**
   * isBookInReadingPlan.
   */
  Future<Result<bool, String>> isBookInReadingPlan(String bookId, String userId) async {
    try {
      final response = await _dio.post(
        '/readingPlans-isBookInReadingPlan',
        data: {
          'bookId': bookId,
          'userId': userId,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );



      if ((response.statusCode == 200 || response.statusCode == 201) && response.data != null) {
        try {
          final raw = response.data['inPlan'];
          final inPlan = raw is bool ? raw : raw.toString().toLowerCase() ==
              'true';
          return Result.success(inPlan);
        }catch(e){
          return Result.failure("Server returned an error: ${response.statusCode}");
        }
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

}