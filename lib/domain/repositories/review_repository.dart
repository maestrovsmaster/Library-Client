import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:leeds_library/data/models/review.dart';
import 'package:leeds_library/data/net/result.dart';

class ReviewsRepository {
  final Dio _dio;
  final FirebaseFirestore firestore;
  final String postfix;

  static const String collectionName = "reviews";
  String collectionPath = collectionName;

  ReviewsRepository(this._dio, this.firestore, {this.postfix = ''}){
    collectionPath = postfix.isEmpty?
    collectionName:
    "$collectionName-$postfix";
  }

  Future<Result<Review?, String>> createReview(Review review) async {
    try {
      final response = await _dio.post(
        '/reviews-createReview',
        data: review.toMap(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print("createReview response = ${response.data}");

      if (response.statusCode == 201 && response.data != null) {
        final data = response.data;
        final docId = data['id'] as String;
        return Result.success(Review.fromMap(data, docId));
      } else {
        return Result.failure("Server returned an error: ${response.statusCode}");
      }
    } catch (e) {
      print('Error creating review: $e');
      return Result.failure("Network error: $e");
    }
  }

  Future<Result<void, String>> updateReview(String bookId, String reviewId, int rate, String text) async {
    try {
      final response = await _dio.post(
        '/reviews-updateReview',
        data: {
          'bookId':bookId,
          'reviewId': reviewId,
          'rate': rate,
          'text': text,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return Result.success(null);
      } else {
        return Result.failure("Server returned error: ${response.statusCode}");
      }
    } catch (e) {
      return Result.failure("Error updating review: $e");
    }
  }


  Future<Result<void, String>> deleteReview(String bookId, String reviewId) async {
    try {
      final response = await _dio.delete(
        '/reviews-deleteReview',
        queryParameters: {
          'bookId':bookId,
          'reviewId': reviewId},
      );

      if (response.statusCode == 200) {
        return Result.success(null);
      } else {
        return Result.failure("Server returned error: ${response.statusCode}");
      }
    } catch (e) {
      return Result.failure("Error deleting review: $e");
    }
  }

  Stream<List<Review>> watchReviewsForBook(String bookId) {
    return firestore
        .collection(collectionPath)
        .where('bookId', isEqualTo: bookId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Review.fromMap(doc.data(), doc.id)).toList());
  }



  Future<List<Review>> getReviewsForBook(String bookId) async {

    final snapshot = await firestore
        .collection(collectionPath)
        .where('bookId', isEqualTo: bookId)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Review.fromMap(doc.data(), doc.id))
        .toList();
  }
}
