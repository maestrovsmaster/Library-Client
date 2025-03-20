import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String genre;
  final String publisher;
  final String description;
  final String imageUrl;
  final String barcode;
  final bool isAvailable;

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
    };
  }

  factory Book.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Конвертуємо Firestore-документ у Map
    if (data == null) {
      throw Exception("Документ не містить даних");
    }

    return Book(
      id: doc.id, // ID беремо з самого документа Firestore
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      genre: data['genre'] ?? '',
      publisher: data['publisher'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      barcode: data['barcode'] ?? '',
      isAvailable: data['isAvailable'] ?? true,
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
    );
  }
}
