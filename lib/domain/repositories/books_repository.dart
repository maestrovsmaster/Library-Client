import 'package:dio/dio.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:leeds_library/data/net/result.dart';

class BooksRepository{
  final Dio _dio;

  BooksRepository(this._dio);


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




  /// Створення нової книги
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
    } catch (e) {
      print('Error creating book: $e');
      return Result.failure("Network error: $e");
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
    } catch (e) {
      print('Error updating book: $e');
      return Result.failure("Network error: $e");
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
    } catch (e) {
      print('Error updating book: $e');
      return Result.failure("Network error: $e");
    }
  }

}