import 'package:presto_cli/src/utils/utils.dart';

ProcessInfo processInfo({
  required int processId,
  bool withStdout = true,
  bool withStderr = true,
}) =>
    ProcessInfo(
      processId: processId,
      processName: 'Process $processId',
      stdout: withStdout ? 'stdout for process $processId' : null,
      stderr: withStderr ? 'stderr for process $processId' : null,
    );
