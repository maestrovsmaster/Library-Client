import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leeds_library/data/models/loan.dart';
import 'package:leeds_library/data/net/result.dart';
import 'package:rxdart/rxdart.dart';


class LoansRepository {
  final Dio _dio;
  final FirebaseFirestore firestore;
  final String postfix;
  final userCubit;

  static const String collectionName = "loans";
  String collectionPath = collectionName;

  final BehaviorSubject<List<Loan>> _loansController =
  BehaviorSubject.seeded([]);

  LoansRepository(this._dio, this.firestore, this.userCubit, {this.postfix = ''}){
    collectionPath = postfix.isEmpty?
    collectionName:
    "$collectionName-$postfix";

    print("LoansRepository collectionPath = $collectionPath");

    _listenToFirestore();
  }


  Stream<List<Loan>> get loansStream => _loansController.stream;

  void _listenToFirestore() {

    bool firstRefreshDone = false;

    firestore.collection(collectionPath)
        //.where('dateReturned', isNull: true)
        .where('dateReturned', whereIn: [''])
        .snapshots()
        .listen((snapshot) {
      // Якщо це кеш, і перше оновлення ще не отримано з мережі — ігноруємо
     /* if (snapshot.metadata.isFromCache && !firstRefreshDone) {
        return;
      }*/

      // Після першого не-кешованого оновлення — прапорець
      if (!snapshot.metadata.isFromCache) {
        firstRefreshDone = true;
      }

      bool hasChanges = false;
      var loans = [..._loansController.value];

      for (var change in snapshot.docChanges) {
        var book = Loan.fromFirestore(change.doc);

        if (change.type == DocumentChangeType.added) {
          if (!loans.any((b) => b.id == book.id)) {
            loans.add(book);
            hasChanges = true;
          }
        } else if (change.type == DocumentChangeType.removed) {
          loans.removeWhere((b) => b.id == book.id);
          hasChanges = true;
        } else if (change.type == DocumentChangeType.modified) {
          var index = loans.indexWhere((b) => b.id == book.id);
          if (index != -1 &&
              (loans[index].dateBorrowed != book.dateBorrowed ||
                  loans[index].dateReturned != book.dateReturned)) {
            loans[index] = book;
            hasChanges = true;
          }
        }
      }

      if (hasChanges) {
        _loansController.add(loans);
      }
    });
  }


  Future<Result<Loan?, String>> createLoan(Loan loan) async {
    try {
      final response = await _dio.post(
        '/loans-createLoan',
        data: loan.toMap(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print("createLoan response = ${response.data}");

      if (response.statusCode == 201 && response.data != null) {
        final data = response.data;
        final docId = data['id'] as String;

        return Result.success(Loan.fromMap(data, docId));
      } else {
        return Result.failure("Server returned an error: ${response.statusCode}");
      }
    } catch (e) {
      print('Error creating loan: $e');
      return Result.failure("Network error: $e");
    }
  }

  Future<Result<bool, String>> closeLoan({String? loanId, String? bookId}) async {
    print("Repository Closing loan with id: ${loanId}, bookId: ${bookId}");
    try {
      final response = await _dio.post(
        '/loans-closeLoan',
        data: {
          if (loanId != null) 'loanId': loanId,
          if (bookId != null) 'bookId': bookId,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      print("Repository Closing response.statusCode: ${response.statusCode}, ");
      if (response.statusCode == 200) {
        return Result.success(true);
      } else {
        return Result.failure("Server returned an error: ${response.statusCode}");
      }
    } catch (e) {
      print('Error closing loan: $e');
      return Result.failure("Network error: $e");
    }
  }

  Future<Result<List<Loan>, String>> getMyLoans() async {

    final userId = userCubit.state.userId;
    print("Repository getMyLoans: ${userId}");
    try {
      final response = await _dio.post(
        '/loans-getMyLoans',
        data: {
          if (userId != null) 'userId': userId,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      print("Repository Closing response.statusCode: ${response.statusCode}, ");
      if (response.statusCode == 200) {

        List<Loan> loans = response.data.map<Loan>((loanData) => Loan.fromJson(loanData)).toList();
        return Result.success(loans);
      } else {
        return Result.failure("Server returned an error: ${response.statusCode}");
      }
    } catch (e) {
      print('Error closing loan: $e');
      return Result.failure("Network error: $e");
    }
  }


  Future<List<Loan>> getActiveLoans() async {

    final snapshot = await firestore
        .collection(collectionPath)
        .where('dateReturned', isNull: true)
        .get();

    return snapshot.docs
        .map((doc) => Loan.fromMap(doc.data(), doc.id))
        .toList();
  }
}
