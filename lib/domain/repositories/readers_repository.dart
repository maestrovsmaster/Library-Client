import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:leeds_library/data/models/reader.dart';
import 'package:leeds_library/data/net/result.dart';

class ReadersRepository {
  final Dio _dio;
  final FirebaseFirestore firestore;
  final String postfix;

  ReadersRepository(this._dio, this.firestore, {this.postfix = ''});

  Future<Result<Reader?, String>> createReader(Reader reader) async {
    try {
      final response = await _dio.post(
        '/readers-createReader',
        data: reader.toMap(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print("createReader response = ${response.data}");

      if (response.statusCode == 201 && response.data != null) {
        final data = response.data;
        final docId = data['id'] as String;

        return Result.success(Reader.fromMap(data, docId));
      } else {
        return Result.failure("Server returned an error: ${response.statusCode}");
      }
    } catch (e) {
      print('Error creating reader: $e');
      return Result.failure("Network error: $e");
    }
  }

  Future<List<Reader>> searchByName(String query) async {
    final bookRepo = 'readers-$postfix';

    final snapshot = await firestore
        .collection(bookRepo)
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    return snapshot.docs
        .map((doc) => Reader.fromMap(doc.data(), doc.id))
        .toList();
  }


}
