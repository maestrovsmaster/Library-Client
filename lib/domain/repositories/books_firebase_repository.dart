import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leeds_library/data/models/book.dart';

class BooksFirebaseRepository {
  final FirebaseFirestore firestore;
  final List<Book> _cachedBooks = [];

  BooksFirebaseRepository({required this.firestore});

  // Підписка на Firestore (один раз на старті)
  void listenToBooksUpdates() {
    firestore.collection("books").snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          _cachedBooks.add(Book.fromFirestore(change.doc));
        } else if (change.type == DocumentChangeType.modified) {
          var updatedBook = Book.fromFirestore(change.doc);
          int index = _cachedBooks.indexWhere((b) => b.id == updatedBook.id);
          if (index != -1) _cachedBooks[index] = updatedBook;
        } else if (change.type == DocumentChangeType.removed) {
          _cachedBooks.removeWhere((b) => b.id == change.doc.id);
        }
      }
    });
  }

  // Отримати всі книги (із кешу або Firestore, якщо кеш пустий)
  Future<List<Book>> getBooks() async {
    if (_cachedBooks.isNotEmpty) return _cachedBooks;

    var snapshot = await firestore.collection("books").get();
    _cachedBooks.clear();
    _cachedBooks.addAll(snapshot.docs.map((doc) => Book.fromFirestore(doc)));
    return _cachedBooks;
  }



  final StreamController<List<Book>> _booksStreamController = StreamController.broadcast();


  Stream<List<Book>> getBooksStream() {
    // Якщо є кеш → одразу віддаємо його у стрім
    if (_cachedBooks.isNotEmpty) {
      _booksStreamController.add(List<Book>.from(_cachedBooks));
    } else {
      // Якщо кешу нема, виконуємо разовий запит у Firestore
      firestore.collection("books").get().then((snapshot) {
        _cachedBooks.clear();
        _cachedBooks.addAll(snapshot.docs.map((doc) => Book.fromFirestore(doc)));
        _booksStreamController.add(List<Book>.from(_cachedBooks));
      });
    }

    // Запускаємо підписку на Firestore, щоб отримувати оновлення в реальному часі
    firestore.collection("books").snapshots().listen((snapshot) {
      bool hasChanges = false;

      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          _cachedBooks.add(Book.fromFirestore(change.doc));
          hasChanges = true;
        } else if (change.type == DocumentChangeType.modified) {
          var updatedBook = Book.fromFirestore(change.doc);
          int index = _cachedBooks.indexWhere((b) => b.id == updatedBook.id);
          if (index != -1) {
            _cachedBooks[index] = updatedBook;
            hasChanges = true;
          }
        } else if (change.type == DocumentChangeType.removed) {
          _cachedBooks.removeWhere((b) => b.id == change.doc.id);
          hasChanges = true;
        }
      }

      //  Якщо є зміни, оновлюємо стрім
      if (hasChanges) {
        _booksStreamController.add(List<Book>.from(_cachedBooks));
      }
    });

    return _booksStreamController.stream;
  }

}
