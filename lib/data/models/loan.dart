import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leeds_library/core/utils/utils.dart';
import 'package:leeds_library/data/models/book.dart';


class Loan {
  final String? id;
  final Book book;
  final Map<String, dynamic> reader;
  final String borrowedBy;
  final DateTime? dateBorrowed;
  final DateTime? dateReturned;

  Loan({
    this.id, // тепер не required
    required this.book,
    required this.reader,
    required this.borrowedBy,
    required this.dateBorrowed,
    this.dateReturned,
  });

  Map<String, dynamic> toMap() => {
    'book': book,
    'reader': reader,
    'borrowedBy': borrowedBy,
    'dateBorrowed': dateBorrowed?.toIso8601String(),
    'dateReturned': dateReturned != null ? dateReturned?.toIso8601String(): null,
  };


  factory Loan.fromMap(Map<String, dynamic> map, String id) => Loan(
    id: id,
    book: Book.fromMap(map['book']),//  Map<String, dynamic>.from(map['book']),
    reader: Map<String, dynamic>.from(map['reader']),
    borrowedBy: map['borrowedBy'],
    dateBorrowed: parseDate(map['dateBorrowed']),
    dateReturned: map['dateReturned'] != null ? parseDate(map['dateReturned']) : null,
  );

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'],
      book:  Book.fromMap(json['book']), // Map<String, dynamic>.from(json['book'] ?? {}),
      reader: Map<String, dynamic>.from(json['reader'] ?? {}),
      borrowedBy: json['borrowedBy'] ?? '',
      dateBorrowed: parseDate(json['dateBorrowed']),
      dateReturned: json['dateReturned'] != null ? parseDate(json['dateReturned']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'book': book,
    'reader': reader,
    'borrowedBy': borrowedBy,
    'dateBorrowed': dateBorrowed?.toIso8601String(),
    'dateReturned': dateReturned?.toIso8601String(),
  };


  factory Loan.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception("Document doesn't contain data");
    }

    return Loan(
      id: doc.id,
      book:  Book.fromJson(data['book'] ?? {}),  ////Map<String, dynamic>.from(data['book'] ?? {}),
      reader: Map<String, dynamic>.from(data['reader'] ?? {}),
      borrowedBy: data['borrowedBy'] ?? '',
      dateBorrowed: parseDate(data['dateBorrowed']),
      dateReturned: data['dateReturned'] != null && data['dateReturned'] != "" ? parseDate(data['dateReturned']) : null,
    );
  }


}

