import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'process_response.freezed.dart';

class ProcessResponse {
  const ProcessResponse({
    required dynamic stdout,
    required dynamic stderr,
    required int exitCode,
    required this.pid,
  })  : _exitCode = exitCode,
        _stderr = stderr,
        _stdout = stdout;

  final int pid;
  final dynamic _stdout;
  final dynamic _stderr;
  final int _exitCode;

  String get stdout => _stdout.toString();
  String get stderr => _stderr.toString();

  ExitCodeStatus get exitCodeStatus {
    if (_exitCode == 0) return const ExitCodeStatus.success(exitCode: 0);
    return ExitCodeStatus.failure(exitCode: _exitCode);
  }

  String get output => 'Stdout:\n$stdout\nStderr:\n$stderr';

  static ProcessResponse fromProcessResult(ProcessResult result) =>
      ProcessResponse(
        stdout: result.stdout,
        stderr: result.stderr,
        exitCode: result.exitCode,
        pid: result.pid,
      );
}

@freezed
class ExitCodeStatus with _$ExitCodeStatus {
  const factory ExitCodeStatus.success({
    required int exitCode,
  }) = _Success;
  const factory ExitCodeStatus.failure({
    required int exitCode,
  }) = _Failure;
}
