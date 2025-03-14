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
