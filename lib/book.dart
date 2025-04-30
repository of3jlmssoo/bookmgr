// import 'package:bookmgr/main.dart';
import 'package:bookmgr/consts.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';
part 'book.g.dart';

// 'CREATE TABLE bookmgr_tbl(id INTEGER, purchased INTEGER, date TEXT, title TEXT, author TEXT, publisher TEXT, genre TEXT, memo Text,PRIMARY KEY(id  AUTOINCREMENT))',
@freezed
abstract class Book with _$Book {
  const factory Book({
    int? id,
    int? purchased,
    String? date,
    required String name,
    String? author,
    Publisher? publisher,
    BookGenre? genre,
    String? comment,
    String? purchasedDate,
    int? next,
  }) = _Book;

  factory Book.fromJson(Map<String, Object?> json) => _$BookFromJson(json);
}
