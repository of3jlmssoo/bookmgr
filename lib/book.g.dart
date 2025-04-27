// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Book _$BookFromJson(Map<String, dynamic> json) => _Book(
  id: (json['id'] as num?)?.toInt(),
  purchased: (json['purchased'] as num?)?.toInt(),
  date: json['date'] as String?,
  name: json['name'] as String,
  author: json['author'] as String?,
  publisher: $enumDecodeNullable(_$PublisherEnumMap, json['publisher']),
  genre: $enumDecodeNullable(_$BookGenreEnumMap, json['genre']),
  comment: json['comment'] as String?,
);

Map<String, dynamic> _$BookToJson(_Book instance) => <String, dynamic>{
  'id': instance.id,
  'purchased': instance.purchased,
  'date': instance.date,
  'name': instance.name,
  'author': instance.author,
  'publisher': _$PublisherEnumMap[instance.publisher],
  'genre': _$BookGenreEnumMap[instance.genre],
  'comment': instance.comment,
};

const _$PublisherEnumMap = {
  Publisher.chikuma: 'chikuma',
  Publisher.chikumap: 'chikumap',
  Publisher.chikumag: 'chikumag',
  Publisher.hayakawab: 'hayakawab',
  Publisher.php: 'php',
  Publisher.asahi: 'asahi',
  Publisher.chuukou: 'chuukou',
  Publisher.koudangakubunn: 'koudangakubunn',
  Publisher.koudangshinsho: 'koudangshinsho',
  Publisher.koudanshaplus: 'koudanshaplus',
  Publisher.bluebacks: 'bluebacks',
  Publisher.koubun: 'koubun',
  Publisher.shincho: 'shincho',
  Publisher.kawada: 'kawada',
  Publisher.shuueisha: 'shuueisha',
  Publisher.iwanamigbunko: 'iwanamigbunko',
  Publisher.iwanamibunko: 'iwanamibunko',
  Publisher.iwanamishinsho: 'iwanamishinsho',
  Publisher.iwanamij: 'iwanamij',
  Publisher.waseda: 'waseda',
  Publisher.fusou: 'fusou',
  Publisher.gentousha: 'gentousha',
  Publisher.shodensha: 'shodensha',
  Publisher.other: 'other',
  Publisher.all: 'all',
};

const _$BookGenreEnumMap = {
  BookGenre.economy: 'economy',
  BookGenre.religion: 'religion',
  BookGenre.it: 'it',
  BookGenre.social: 'social',
  BookGenre.philosophy: 'philosophy',
  BookGenre.politics: 'politics',
  BookGenre.literature: 'literature',
  BookGenre.biz: 'biz',
  BookGenre.language: 'language',
  BookGenre.art: 'art',
  BookGenre.hobby: 'hobby',
  BookGenre.science: 'science',
  BookGenre.other: 'other',
  BookGenre.all: 'all',
};
