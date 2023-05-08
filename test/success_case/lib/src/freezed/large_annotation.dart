import 'package:freezed_annotation/freezed_annotation.dart';

part 'large_annotation.freezed.dart';

@Freezed()
class Person with _$Person {
  const factory Person({
    required String firstName,
    required String lastName,
    required int age,
  }) = _Person;
}
