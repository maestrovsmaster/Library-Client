import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:leeds_library/data/models/book.dart';
import 'package:rxdart/rxdart.dart';

class BooksFirebaseRepository {
  final FirebaseFirestore firestore;
  final Box<Book> bookBox;
  final String postfix;

  final BehaviorSubject<List<Book>> _booksController =
      BehaviorSubject.seeded([]);

  final List<String> catetories = [];

  BooksFirebaseRepository(this.firestore, this.bookBox, {this.postfix = ''}) {
    _loadCachedBooks();
    _listenToFirestore();
  }

  Stream<List<Book>> get booksStream => _booksController.stream;

  void _loadCachedBooks() {
    if (bookBox.isNotEmpty) {
      _booksController.add(bookBox.values.toList());
    }
  }

  void _listenToFirestore() {
    final bookRepo = postfix.isEmpty?
     "books":
      "books-$postfix";

    print("bookRepo: $bookRepo");
    firestore.collection(bookRepo).snapshots().listen((snapshot) {
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
          if (index != -1 &&
              (books[index].barcode != book.barcode ||
                  books[index].isAvailable != book.isAvailable)) {
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
}
