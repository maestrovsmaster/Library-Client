import 'package:leeds_library/core/utils/utils.dart';

class Review {
  final String id;
  final String bookId;
  final String userId;
  final String userName;
  final String userAvatarUrl;
  final int rate;
  final String text;
  final DateTime? date;
  final DateTime? dateUpdated;

  Review({
    required this.id,
    required this.bookId,
    required this.userId,
    required this.userName,
    required this.userAvatarUrl,
    required this.rate,
    required this.text,
    required this.date,
    this.dateUpdated,
  });

  Map<String, dynamic> toMap() => {
        'bookId': bookId,
        'userId': userId,
        'userName': userName,
        'userAvatarUrl': userAvatarUrl,
        'rate': rate,
        'text': text,
        'date': date?.toIso8601String(),
        'dateUpdated':
            dateUpdated != null ? dateUpdated!.toIso8601String() : null,
      };

  factory Review.fromMap(Map<String, dynamic> map, String id) => Review(
        id: id,
        bookId: map['bookId'] ?? '',
        userId: map['userId'] ?? '',
        userName: map['userName'] ?? '',
        userAvatarUrl: map['userAvatarUrl'] ?? '',
        rate: map['rate'] ?? 0,
        text: map['text'] ?? '',
        date: parseDate(map['date']),
        dateUpdated:
            map['dateUpdated'] != null ? parseDate(map['dateUpdated']) : null,
      );

  //copyWith
  Review copyWith({
    String? id,
    String? bookId,
    String? userId,
    String? userName,
    String? userAvatarUrl,
    int? rate,
    String? text,
    DateTime? date,
    DateTime? dateUpdated,
  }) {
    return Review(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      rate: rate ?? this.rate,
      text: text ?? this.text,
      date: date ?? this.date,
      dateUpdated: dateUpdated ?? this.dateUpdated,
    );
  }
}
