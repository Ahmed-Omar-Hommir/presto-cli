import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dartz/dartz.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:presto_cli/src/commands/make/commands/magic_runner_command.dart';
import 'package:presto_cli/src/logger.dart';
import 'package:presto_cli/src/models/file_manager/file_manager_failure.dart';
import 'package:presto_cli/src/package_manager.dart';
import 'package:test/test.dart';

import 'helper.dart';
import 'magic_runner_command_test.mocks.dart';

@GenerateMocks([
  PackageManager,
  IFileManager,
  ILogger,
  IFlutterCLI,
  Process,
])
void main() {
  late CommandRunner<int> sut;
  late Directory currentDir;
  late MocksProvider mocksProvider;

  // mocks
  late MockIFileManager mockFileManager;
  late MockILogger mockLogger;
  late MockIFlutterCLI mockFlutterCli;
  late MockProcess mockProcess;

  setUp(() {
    mockFileManager = MockIFileManager();
    mockLogger = MockILogger();
    mockFlutterCli = MockIFlutterCLI();
    mockProcess = MockProcess();

    when(mockProcess.stderr).thenAnswer((_) => Stream.value(
          stderrMessage.codeUnits,
        ));
    when(mockProcess.stdout).thenAnswer((_) => Stream.value(
          stdoutMessage.codeUnits,
        ));
    when(mockProcess.exitCode).thenAnswer((_) async => 0);

    currentDir = Directory.systemTemp.createTempSync();

    sut = CommandRunner<int>('test', 'test')
      ..addCommand(MagicRunnerCommand(
        flutterCli: mockFlutterCli,
        fileManager: mockFileManager,
        logger: mockLogger,
        currentDir: currentDir,
      ));

    mocksProvider = MocksProvider(
      mockFileManager: mockFileManager,
      mockLogger: mockLogger,
      mockFlutterCLI: mockFlutterCli,
    );
  });

  tearDown(() {
    currentDir.deleteSync(recursive: true);
  });

  group('Success cases', () {
    test(
      'should return success code when command is executed successfully.',
      () async {
        // Arrange
        mocksProvider.allMocks(
          mockFlutterCli: (mock) {
            for (var dir in {...packageDirectories, currentDir}) {
              when(mock.buildRunner(dir)).thenAnswer(
                (_) async => right(mockProcess),
              );
            }
          },
          mockFileManager: (mock) {
            when(mock.readYaml(any)).thenAnswer(
              (_) async => Right(yamlContent()),
            );
            when(mock.findPackages(any)).thenAnswer(
              (_) async => Right(packageDirectories),
            );
          },
          mockLogger: (mock) {
            when(mock.error(any)).thenReturn(null);
            when(mock.info(any)).thenReturn(null);
          },
        );

        // Act
        final exitCode = await sut.run([magicRunnercommand]);

        // Assert
        expect(exitCode, ExitCode.success.code);

        mocksProvider.allMocks(
          mockFlutterCli: (mock) {
            for (var dir in {...packageDirectories, currentDir}) {
              verify(mock.buildRunner(dir)).called(1);
            }
            verifyNoMoreInteractions(mock);
          },
          mockFileManager: (mock) {
            verify(mock.readYaml(any)).called(1);
            verify(mock.findPackages(any)).called(1);
            verifyNoMoreInteractions(mock);
          },
          mockLogger: (mock) {
            verify(mock.info(stdoutMessage)).called(4);
            verify(mock.info(stderrMessage)).called(4);
            verifyNoMoreInteractions(mock);
          },
        );
      },
    );
    test(
      'should return success code and print log error when build_runner returns different failure types.',
      () async {
        // Arrange
        mocksProvider.allMocks(
          mockFlutterCli: (mock) {
            when(mock.buildRunner(packageDirectories.elementAt(0))).thenAnswer(
              (_) async => left(CliFailure.directoryNotFound()),
            );

            when(mock.buildRunner(packageDirectories.elementAt(1))).thenAnswer(
              (_) async => left(CliFailure.unknown('Error')),
            );

            when(mock.buildRunner(packageDirectories.elementAt(2))).thenAnswer(
              (_) async => left(CliFailure.packageAlreadyExists()),
            );

            when(mock.buildRunner(currentDir)).thenAnswer(
              (_) async => right(mockProcess),
            );
          },
          mockFileManager: (mock) {
            when(mock.readYaml(any)).thenAnswer(
              (_) async => Right(yamlContent()),
            );
            when(mock.findPackages(any)).thenAnswer(
              (_) async => Right(packageDirectories),
            );
          },
          mockLogger: (mock) {
            when(mock.error(any)).thenReturn(null);
            when(mock.info(any)).thenReturn(null);
          },
        );

        // Act
        final exitCode = await sut.run([magicRunnercommand]);

        // Assert
        expect(exitCode, ExitCode.success.code);

        mocksProvider.allMocks(
          mockFlutterCli: (mock) {
            for (var dir in {...packageDirectories, currentDir}) {
              verify(mock.buildRunner(dir)).called(1);
            }
            verifyNoMoreInteractions(mock);
          },
          mockFileManager: (mock) {
            verify(mock.readYaml(any)).called(1);
            verify(mock.findPackages(any)).called(1);
            verifyNoMoreInteractions(mock);
          },
          mockLogger: (mock) {
            verify(mock.error(LoggerMessage.directoryNotFound)).called(1);
            verify(mock.error(LoggerMessage.somethingWentWrong)).called(1);
            verify(mock.error('Error')).called(1);
            verify(mock.info(stderrMessage)).called(1);
            verify(mock.info(stdoutMessage)).called(1);
            verifyNoMoreInteractions(mock);
          },
        );
      },
    );
  });

  group('Failure cases', () {
    test(
      'should print error and return noInput code when readYaml return $FileManagerFailureFileNotFound.',
      () async {
        // Arrange
        when(mockFileManager.readYaml(any)).thenAnswer(
          (_) async => Left(FileManagerFailure.fileNotFound()),
        );
        when(mockLogger.error(any)).thenReturn(null);

        // Act
        final exitCode = await sut.run([magicRunnercommand]);

        // Assert
        expect(exitCode, ExitCode.noInput.code);

        verify(mockLogger.error(any)).called(1);
        verify(mockFileManager.readYaml(any)).called(1);

        verifyNoMoreInteractions(mockLogger);
        verifyNoMoreInteractions(mockFileManager);

        verifyZeroInteractions(mockFlutterCli);
      },
    );

    test(
      'should print error and return unavailable code when readYaml return $FileManagerFailureUnknown.',
      () async {
        // Arrange
        when(mockFileManager.readYaml(any)).thenAnswer(
          (_) async => Left(FileManagerFailure.unknown("Error")),
        );
        when(mockLogger.error(any)).thenReturn(null);

        // Act
        final exitCode = await sut.run([magicRunnercommand]);

        // Assert
        expect(exitCode, ExitCode.unavailable.code);

        verify(mockLogger.error(any)).called(1);
        verify(mockFileManager.readYaml(any)).called(1);

        verifyNoMoreInteractions(mockLogger);
        verifyNoMoreInteractions(mockFileManager);

        verifyZeroInteractions(mockFlutterCli);
      },
    );

    test(
      'should print error and return noInput code if package name is not match.',
      () async {
        // Arrange
        when(mockFileManager.readYaml(any)).thenAnswer(
          (_) async => Right(yamlContent(name: 'not_match_package_name')),
        );
        when(mockLogger.error(any)).thenReturn(null);

        // Act
        final exitCode = await sut.run([magicRunnercommand]);

        // Assert
        expect(exitCode, ExitCode.noInput.code);

        verify(mockLogger.error(any)).called(1);
        verify(mockFileManager.readYaml(any)).called(1);

        verifyNoMoreInteractions(mockLogger);
        verifyNoMoreInteractions(mockFileManager);

        verifyZeroInteractions(mockFlutterCli);
      },
    );
    test(
      'should print error and return noInput code if findPackages retrun $FileManagerFailureDirNotFound.',
      () async {
        // Arrange
        when(mockFileManager.readYaml(any)).thenAnswer(
          (_) async => Right(yamlContent()),
        );
        when(mockFileManager.findPackages(any)).thenAnswer(
          (_) async => Left(FileManagerFailure.dirNotFound()),
        );
        when(mockLogger.error(LoggerMessage.youAreNotInRootProject))
            .thenReturn(null);

        // Act
        final exitCode = await sut.run([magicRunnercommand]);

        // Assert
        expect(exitCode, ExitCode.noInput.code);

        verify(mockLogger.error(LoggerMessage.youAreNotInRootProject))
            .called(1);
        verify(mockFileManager.readYaml(any)).called(1);
        verify(mockFileManager.findPackages(any)).called(1);

        verifyNoMoreInteractions(mockLogger);
        verifyNoMoreInteractions(mockFileManager);

        verifyZeroInteractions(mockFlutterCli);
      },
    );
    test(
      'should print error and return unavailable code if findPackages retrun orElse.',
      () async {
        // Arrange
        when(mockFileManager.readYaml(any)).thenAnswer(
          (_) async => Right(yamlContent()),
        );
        when(mockFileManager.findPackages(any)).thenAnswer(
          (_) async => Left(FileManagerFailure.fileNotFound()),
        );
        when(mockLogger.error(LoggerMessage.somethingWentWrong))
            .thenReturn(null);

        // Act
        final exitCode = await sut.run([magicRunnercommand]);

        // Assert
        expect(exitCode, ExitCode.unavailable.code);

        verify(mockLogger.error(LoggerMessage.somethingWentWrong)).called(1);
        verify(mockFileManager.readYaml(any)).called(1);
        verify(mockFileManager.findPackages(any)).called(1);

        verifyNoMoreInteractions(mockLogger);
        verifyNoMoreInteractions(mockFileManager);

        verifyZeroInteractions(mockFlutterCli);
      },
    );
  });
}
