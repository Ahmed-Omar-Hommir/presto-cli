import 'package:freezed_annotation/freezed_annotation.dart';

part 'arguments.freezed.dart';

@freezed
class Arguments with _$Arguments {
  const factory Arguments.help() = _Help;
  const factory Arguments.packages() = _Packages;
  const factory Arguments.unknown(String command) = _Unknown;
}
