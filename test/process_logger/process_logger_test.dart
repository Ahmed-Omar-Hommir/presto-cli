import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:presto_cli/src/logger.dart';
import 'package:presto_cli/src/utils/utils.dart';
import 'package:test/test.dart';

import 'helper.dart';
import 'parallel_process_logger_test.mocks.dart';

@GenerateMocks([ILogger])
void main() {
  late ProcessLogger sut;
  late MockILogger mockLogger;

  setUp(() {
    mockLogger = MockILogger();
    sut = ProcessLogger(logger: mockLogger);

    when(mockLogger.info(any)).thenReturn(null);
    when(mockLogger.error(any)).thenReturn(null);
  });

  test('should print process name and stdout when call stdout method.', () {
    // Arrange
    final processId = 1;
    final processName = getProcessName(processId);
    final stdout = getStdout(processId);

    // Act
    sut.stdout(
      processId: processId,
      processName: processName,
      stdout: stdout,
    );

    // Assert
    verifyInOrder([
      mockLogger.info(argThat(contains(processName))),
      mockLogger.info(stdout),
    ]);

    verifyNoMoreInteractions(mockLogger);
  });

  test('should print process name and stdout when call stderr method.', () {
    // Arrange
    final processId = 1;
    final processName = getProcessName(processId);
    final stderr = getStderr(processId);

    // Act
    sut.stderr(
      processId: processId,
      processName: processName,
      stderr: stderr,
    );

    // Assert
    verifyInOrder([
      mockLogger.info(argThat(contains(processName))),
      mockLogger.error(stderr),
    ]);

    verifyNoMoreInteractions(mockLogger);
  });

  test(
      'should print one process name when call stdout and stderr methods multiple and procees id not changed.',
      () {
    // Arrange
    final processId = 1;
    final processName = getProcessName(processId);
    final stderr = getStderr(processId);
    final stdout = getStdout(processId);

    // Act
    sut.stdout(
      processId: processId,
      processName: processName,
      stdout: stdout,
    );
    sut.stderr(
      processId: processId,
      processName: processName,
      stderr: stderr,
    );
    sut.stdout(
      processId: processId,
      processName: processName,
      stdout: stdout,
    );
    sut.stderr(
      processId: processId,
      processName: processName,
      stderr: stderr,
    );

    // Assert
    verifyInOrder([
      mockLogger.info(argThat(contains(processName))),
      mockLogger.info(stdout),
      mockLogger.error(stderr),
      mockLogger.info(stdout),
      mockLogger.error(stderr),
    ]);

    verifyNoMoreInteractions(mockLogger);
  });
  test('should print process name each procees id changed.', () {
    // Arrange
    final processIdA = 1;
    final processNameA = getProcessName(processIdA);
    final stderrA = getStderr(processIdA);
    final stdoutA = getStdout(processIdA);

    final processIdB = 2;
    final processNameB = getProcessName(processIdB);
    final stdoutB = getStdout(processIdB);

    // Act
    sut.stdout(
      processId: processIdA,
      processName: processNameA,
      stdout: stdoutA,
    );
    sut.stderr(
      processId: processIdA,
      processName: processNameA,
      stderr: stderrA,
    );
    sut.stdout(
      processId: processIdB,
      processName: processNameB,
      stdout: stdoutB,
    );
    sut.stderr(
      processId: processIdA,
      processName: processNameA,
      stderr: stderrA,
    );

    // Assert
    verifyInOrder([
      mockLogger.info(argThat(contains(processNameA))),
      mockLogger.info(stdoutA),
      mockLogger.error(stderrA),
      mockLogger.info(argThat(contains(processNameB))),
      mockLogger.info(stdoutB),
      mockLogger.info(argThat(contains(processNameA))),
      mockLogger.error(stderrA),
    ]);

    verifyNoMoreInteractions(mockLogger);
  });
}
