import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_manager_failure.freezed.dart';

@freezed
class FileManagerFailure with _$FileManagerFailure {
  const factory FileManagerFailure.fileNotFound() =
      FileManagerFailureFileNotFound;
  const factory FileManagerFailure.dirNotFound() =
      FileManagerFailureDirNotFound;
  const factory FileManagerFailure.unknown(Object? e) =
      FileManagerFailureUnknown;
}
