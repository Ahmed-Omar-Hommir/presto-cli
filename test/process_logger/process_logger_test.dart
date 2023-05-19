import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:presto_cli/src/logger.dart';
import 'package:presto_cli/src/utils/utils.dart';
import 'package:test/test.dart';

import '../magic_runner_command/magic_runner_command_test.mocks.dart';
import 'helper.dart';

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

  test(
      'should print process name for first logger and stdout and stderr for second logger.',
      () {
    // Arrange
    final info = processInfo(processId: 1);

    // Act
    sut.log(info);

    // Assert
    verifyInOrder([
      mockLogger.info(argThat(contains(info.processName))),
      mockLogger.info(info.stdout),
      mockLogger.error(info.stderr),
    ]);

    verifyNoMoreInteractions(mockLogger);
  });
  test(
      'should print only stdout and stderr for second logger when process id not changed.',
      () {
    // Arrange
    final info = processInfo(processId: 1);

    // Act
    sut.log(info);
    sut.log(info);

    // Assert
    verifyInOrder([
      mockLogger.info(argThat(contains(info.processName))),
      mockLogger.info(info.stdout),
      mockLogger.error(info.stderr),
      mockLogger.info(info.stdout),
      mockLogger.error(info.stderr),
    ]);

    verifyNoMoreInteractions(mockLogger);
  });
  test(
      'should print process name and stdout and stderr for second logger when process id changed.',
      () {
    // Arrange
    final infoA = processInfo(processId: 1);
    final infoB = processInfo(processId: 2);

    // Act
    sut.log(infoA);
    sut.log(infoB);

    // Assert
    verifyInOrder([
      mockLogger.info(argThat(contains(infoA.processName))),
      mockLogger.info(infoA.stdout),
      mockLogger.error(infoA.stderr),
      mockLogger.info(argThat(contains(infoB.processName))),
      mockLogger.info(infoB.stdout),
      mockLogger.error(infoB.stderr),
    ]);

    verifyNoMoreInteractions(mockLogger);
  });
  test(
    'should print nothing when stdout and stderr is null.',
    () {
      // Arrange
      final info = processInfo(
        processId: 1,
        withStderr: false,
        withStdout: false,
      );

      // Act
      sut.log(info);

      // Assert
      verifyZeroInteractions(mockLogger);
    },
  );

  test(
      'should ignore the print process name when trying to log a process between the same process id, with a different id, and stdout and stderr are null.',
      () {
    // Arrange
    final infoA = processInfo(processId: 1);
    final infoB = processInfo(
      processId: 2,
      withStderr: false,
      withStdout: false,
    );

    // Act
    sut.log(infoA);
    sut.log(infoB);
    sut.log(infoA);

    // Assert
    verifyInOrder([
      mockLogger.info(argThat(contains(infoA.processName))),
      mockLogger.info(infoA.stdout),
      mockLogger.error(infoA.stderr),
      mockLogger.info(infoA.stdout),
      mockLogger.error(infoA.stderr),
    ]);

    verifyNoMoreInteractions(mockLogger);
  });

  test('should print stdout only when stderr is null.', () {
    // Arrange
    final info = processInfo(
      processId: 1,
      withStderr: false,
    );

    // Act
    sut.log(info);

    // Assert
    verifyInOrder([
      mockLogger.info(argThat(contains(info.processName))),
      mockLogger.info(info.stdout),
    ]);

    verifyNoMoreInteractions(mockLogger);
  });
  test('should print stderr only when stdout is null.', () {
    // Arrange
    final info = processInfo(
      processId: 1,
      withStdout: false,
    );

    // Act
    sut.log(info);

    // Assert
    verifyInOrder([
      mockLogger.info(argThat(contains(info.processName))),
      mockLogger.error(info.stderr),
    ]);

    verifyNoMoreInteractions(mockLogger);
  });
}
