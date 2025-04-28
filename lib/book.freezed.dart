// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Book {

 int? get id; int? get purchased; String? get date; String get name; String? get author; Publisher? get publisher; BookGenre? get genre; String? get comment; String? get purchasedDate;
/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookCopyWith<Book> get copyWith => _$BookCopyWithImpl<Book>(this as Book, _$identity);

  /// Serializes this Book to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Book&&(identical(other.id, id) || other.id == id)&&(identical(other.purchased, purchased) || other.purchased == purchased)&&(identical(other.date, date) || other.date == date)&&(identical(other.name, name) || other.name == name)&&(identical(other.author, author) || other.author == author)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.purchasedDate, purchasedDate) || other.purchasedDate == purchasedDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,purchased,date,name,author,publisher,genre,comment,purchasedDate);

@override
String toString() {
  return 'Book(id: $id, purchased: $purchased, date: $date, name: $name, author: $author, publisher: $publisher, genre: $genre, comment: $comment, purchasedDate: $purchasedDate)';
}


}

/// @nodoc
abstract mixin class $BookCopyWith<$Res>  {
  factory $BookCopyWith(Book value, $Res Function(Book) _then) = _$BookCopyWithImpl;
@useResult
$Res call({
 int? id, int? purchased, String? date, String name, String? author, Publisher? publisher, BookGenre? genre, String? comment, String? purchasedDate
});




}
/// @nodoc
class _$BookCopyWithImpl<$Res>
    implements $BookCopyWith<$Res> {
  _$BookCopyWithImpl(this._self, this._then);

  final Book _self;
  final $Res Function(Book) _then;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? purchased = freezed,Object? date = freezed,Object? name = null,Object? author = freezed,Object? publisher = freezed,Object? genre = freezed,Object? comment = freezed,Object? purchasedDate = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,purchased: freezed == purchased ? _self.purchased : purchased // ignore: cast_nullable_to_non_nullable
as int?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as Publisher?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as BookGenre?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,purchasedDate: freezed == purchasedDate ? _self.purchasedDate : purchasedDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Book implements Book {
  const _Book({this.id, this.purchased, this.date, required this.name, this.author, this.publisher, this.genre, this.comment, this.purchasedDate});
  factory _Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

@override final  int? id;
@override final  int? purchased;
@override final  String? date;
@override final  String name;
@override final  String? author;
@override final  Publisher? publisher;
@override final  BookGenre? genre;
@override final  String? comment;
@override final  String? purchasedDate;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookCopyWith<_Book> get copyWith => __$BookCopyWithImpl<_Book>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Book&&(identical(other.id, id) || other.id == id)&&(identical(other.purchased, purchased) || other.purchased == purchased)&&(identical(other.date, date) || other.date == date)&&(identical(other.name, name) || other.name == name)&&(identical(other.author, author) || other.author == author)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.purchasedDate, purchasedDate) || other.purchasedDate == purchasedDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,purchased,date,name,author,publisher,genre,comment,purchasedDate);

@override
String toString() {
  return 'Book(id: $id, purchased: $purchased, date: $date, name: $name, author: $author, publisher: $publisher, genre: $genre, comment: $comment, purchasedDate: $purchasedDate)';
}


}

/// @nodoc
abstract mixin class _$BookCopyWith<$Res> implements $BookCopyWith<$Res> {
  factory _$BookCopyWith(_Book value, $Res Function(_Book) _then) = __$BookCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? purchased, String? date, String name, String? author, Publisher? publisher, BookGenre? genre, String? comment, String? purchasedDate
});




}
/// @nodoc
class __$BookCopyWithImpl<$Res>
    implements _$BookCopyWith<$Res> {
  __$BookCopyWithImpl(this._self, this._then);

  final _Book _self;
  final $Res Function(_Book) _then;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? purchased = freezed,Object? date = freezed,Object? name = null,Object? author = freezed,Object? publisher = freezed,Object? genre = freezed,Object? comment = freezed,Object? purchasedDate = freezed,}) {
  return _then(_Book(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,purchased: freezed == purchased ? _self.purchased : purchased // ignore: cast_nullable_to_non_nullable
as int?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as Publisher?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as BookGenre?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,purchasedDate: freezed == purchasedDate ? _self.purchasedDate : purchasedDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
