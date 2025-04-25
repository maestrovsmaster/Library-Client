import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'book.g.dart';

//Command for generating Hive models: flutter pub run build_runner build
@HiveType(typeId: 0)
class Book {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String author;

  @HiveField(3)
  final String genre;

  @HiveField(4)
  final String publisher;

  @HiveField(5)
  final String description;

  @HiveField(6)
  final String imageUrl;

  @HiveField(7)
  final String barcode;

  @HiveField(8)
  final bool isAvailable;

  @HiveField(9)
  final double? averageRating;

  @HiveField(10)
  final int? reviewsCount;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.publisher,
    required this.description,
    required this.imageUrl,
    required this.barcode,
    required this.isAvailable,
    required this.averageRating,
    required this.reviewsCount,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      genre: json['genre'] ?? '',
      publisher: json['publisher'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      barcode: json['barcode'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      averageRating: json['averageRating'] ?? 0.0,
      reviewsCount: json['reviewsCount'] ?? 0,
    );
  }

  factory Book.fromMap(Map<String, dynamic> map){
   return Book(
     id: map['id'] ?? '',
     title: map['title'] ?? '',
     author: map['author'] ?? '',
     genre: map['genre'] ?? '',
     publisher: map['publisher'] ?? '',
     description: map['description'] ?? '',
     imageUrl: map['imageUrl'] ?? '',
     barcode: map['barcode'] ?? '',
     isAvailable: map['isAvailable'] ?? true,
     averageRating: 0,//(map['averageRating'] != null ?? map['averageRating'] ?? 0),
     reviewsCount: 0,//map['reviewsCount'] ?? 0,
   );
  }




  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'genre': genre,
      'publisher': publisher,
      'description': description,
      'imageUrl': imageUrl,
      'barcode': barcode,
      'isAvailable': isAvailable,
      'averageRating': averageRating,
      'reviewsCount': reviewsCount,
    };
  }

  factory Book.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()
        as Map<String, dynamic>?; // Конвертуємо Firestore-документ у Map
    if (data == null) {
      throw Exception("Document doesn't contain data");
    }

    return Book(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      genre: data['genre'] ?? '',
      publisher: data['publisher'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      barcode: data['barcode'] ?? '',
      isAvailable: data['isAvailable'] ?? true,
      averageRating: (data['averageRating'] != null)
          ? (data['averageRating'] as num).toDouble()
          : 0.0,

      reviewsCount: data['reviewsCount'] ?? 0,
    );
  }

  Book copyWith({
    String? title,
    String? author,
    String? genre,
    String? publisher,
    String? description,
    String? imageUrl,
    String? barcode,
    bool? isAvailable,
    double? averageRating,
    int? reviewsCount,
  }) {
    return Book(
      id: this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      publisher: publisher ?? this.publisher,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      barcode: barcode ?? this.barcode,
      isAvailable: isAvailable ?? this.isAvailable,
      averageRating: averageRating ?? this.averageRating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
    );
  }

  static Book empty() => Book(
      id: '',
      title: '',
      barcode: '',
      author: '',
      genre: '',
      publisher: '',
      description: '',
      imageUrl: '',
      isAvailable: false,
      averageRating: 0,
      reviewsCount: 0,

  );
}
