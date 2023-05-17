import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'process_response.freezed.dart';

class ProcessResponse {
  const ProcessResponse({
    required this.stdout,
    required this.stderr,
    required int exitCode,
    required this.pid,
  }) : _exitCode = exitCode;

  final int pid;
  final dynamic stdout;
  final dynamic stderr;
  final int _exitCode;

  ExitCodeStatus get exitCodeStatus {
    if (_exitCode == 0) return const ExitCodeStatus.success(exitCode: 0);
    return ExitCodeStatus.failure(exitCode: _exitCode);
  }

  String get output {
    final output = String.fromCharCodes(stdout);
    final error = String.fromCharCodes(stderr);

    final stdoutMsg = output.isNotEmpty ? 'Stdout:\n$output\n' : '';
    final stderrMsg = error.isNotEmpty ? 'Stdout:\n$error\n' : '';

    return '$stdoutMsg$stderrMsg';
  }

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
