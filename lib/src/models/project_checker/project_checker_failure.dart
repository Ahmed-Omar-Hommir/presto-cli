import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_checker_failure.freezed.dart';

@freezed
class ProjectCheckerFailure with _$ProjectCheckerFailure {
  const factory ProjectCheckerFailure.unknown(Object? e) =
      ProjectCheckerFailureUnknown;
}
