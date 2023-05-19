import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presto_cli/src/logger.dart';

abstract class IProcessLogger {
  void stdout({
    required int processId,
    required String processName,
    required String stdout,
  });
  void stderr({
    required int processId,
    required String processName,
    required String stderr,
  });
}

class ProcessLogger implements IProcessLogger {
  ProcessLogger({
    @visibleForTesting ILogger? logger,
  }) : _logger = logger ?? Logger();

  final ILogger _logger;

  int? _lastProcessId;

  void _handleProcessChange(
    int processId,
    String processName,
  ) {
    if (_lastProcessId != processId) {
      _logger.info('Process [$processName]');
      _lastProcessId = processId;
    }
  }

  @override
  void stderr({
    required int processId,
    required String processName,
    required String stderr,
  }) {
    _handleProcessChange(processId, processName);
    _logger.error(stderr);
  }

  @override
  void stdout({
    required int processId,
    required String processName,
    required String stdout,
  }) {
    _handleProcessChange(processId, processName);
    _logger.info(stdout);
  }
}
