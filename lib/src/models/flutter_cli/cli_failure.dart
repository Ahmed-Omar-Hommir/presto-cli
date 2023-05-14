import 'package:freezed_annotation/freezed_annotation.dart';

part 'cli_failure.freezed.dart';

@freezed
class CliFailure with _$CliFailure {
  const factory CliFailure.pubspecFileNotFound() =
      CliFailurePubspecFileNotFound;
  const factory CliFailure.invalidPackageName() = CliFailureInvalidPackageName;
  const factory CliFailure.packageAlreadyExists() =
      CliFailurePackageAlreadyExists;
  const factory CliFailure.emptyDependencies() = CliFailureEmptyDependencies;
  const factory CliFailure.unknown(Object? e) = CliFailureUnknown;
}
