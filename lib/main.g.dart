// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Book _$BookFromJson(Map<String, dynamic> json) => _Book(
  name: json['name'] as String,
  author: json['author'] as String?,
  publisher: json['publisher'] as String?,
);

Map<String, dynamic> _$BookToJson(_Book instance) => <String, dynamic>{
  'name': instance.name,
  'author': instance.author,
  'publisher': instance.publisher,
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exampleHash() => r'e75fe2037fef7a3f80e04fa007fe64d719dba2fd';

/// See also [example].
@ProviderFor(example)
final exampleProvider = AutoDisposeProvider<String>.internal(
  example,
  name: r'exampleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$exampleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExampleRef = AutoDisposeProviderRef<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
