import 'package:bookmgr/main.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
abstract class Book with _$Book {
  const factory Book({required String name, String? author, String? publisher}) = _Book;

  factory Book.fromJson(Map<String, Object?> json) => _$BookFromJson(json);
}
