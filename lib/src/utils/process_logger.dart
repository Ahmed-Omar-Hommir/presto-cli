
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presto_cli/src/logger.dart';

abstract class IProcessLogger {
  void log(ProcessInfo info);
}

class ProcessLogger implements IProcessLogger {
  ProcessLogger({
    @visibleForTesting ILogger? logger,
  }) : _logger = logger ?? Logger();

  final ILogger _logger;

  int? _lastProcessId;

  @override
  void log(ProcessInfo info) {
    final stdout = info.stdout;
    final stderr = info.stderr;

    if (info.stderr == null && info.stdout == null) return;

    if (_lastProcessId != info.processId) {
      _logger.info('Process [${info.processName}]');
    }

    if (stdout != null) {
      _logger.info(stdout);
    }

    if (stderr != null) {
      _logger.error(stderr);
    }

    _lastProcessId = info.processId;
  }
}

class ProcessInfo {
  const ProcessInfo({
    required this.processId,
    required this.processName,
    required this.stdout,
    required this.stderr,
  });

  final int processId;
  final String processName;
  final String? stdout;
  final String? stderr;
}
