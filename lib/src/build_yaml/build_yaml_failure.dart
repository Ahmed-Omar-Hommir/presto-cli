import 'package:freezed_annotation/freezed_annotation.dart';

part 'build_yaml_failure.freezed.dart';

@freezed
class BuildYamlFailure with _$BuildYamlFailure {
  const factory BuildYamlFailure.pubspecFileIsNotExist() =
      BuildYamlFailurePubspecFileIsNotExist;
  const factory BuildYamlFailure.buildRunnerIsNotExist() =
      BuildYamlFailureBuildRunnerIsNotExist;
  const factory BuildYamlFailure.unknown() = BuildYamlFailureUnknown;
}
