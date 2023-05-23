import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as path;
import 'package:presto_cli/src/commands/magic/commands/magic_runner_command.dart';
import 'package:presto_cli/src/logger.dart';
import 'package:presto_cli/src/models/file_manager/file_manager_failure.dart';
import 'package:presto_cli/src/models/models.dart';
import 'package:presto_cli/src/utils/magic_lancher_strategies.dart';
import 'package:presto_cli/src/utils/utils.dart';
import 'package:test/test.dart';

import 'helper.dart';
import 'magic_launcher_test.mocks.dart';

@GenerateMocks([
  IProjectChecker,
  ILogger,
  IFileManager,
  IMagicCommandStrategy,
  Process,
  IProcessLogger,
])
void main() {
  late IMagicLauncher sut;
  late Directory tempDir;
  late Directory packagesDir;

  late MockIProjectChecker mockIProjectChecker;
  late MockILogger mockILogger;
  late MockIFileManager mockFileManager;
  late MockIMagicCommandStrategy mockIMagicCommandStrategy;
  late MockProcess mockProcess;
  late MockIProcessLogger mockIProcessLogger;

  late TaskRunner taskRunner;
  late Set<Directory> packages;
  late int callCount;

  setUp(() {
    mockIProjectChecker = MockIProjectChecker();
    mockILogger = MockILogger();
    mockFileManager = MockIFileManager();
    taskRunner = TaskRunner();
    mockIMagicCommandStrategy = MockIMagicCommandStrategy();
    mockProcess = MockProcess();
    mockIProcessLogger = MockIProcessLogger();
    sut = MagicLauncher(
      projectChecker: mockIProjectChecker,
      logger: mockILogger,
      fileManager: mockFileManager,
      tasksRunner: taskRunner,
      processLogger: mockIProcessLogger,
    );

    final dir = Directory.systemTemp.createTempSync();
    Directory.current = dir;
    tempDir = Directory.current;

    packagesDir = Directory(path.join(tempDir.path, 'packages'));
    packagesDir.createSync();

    packages = {
      Directory(path.join(packagesDir.path, 'package1'))..createSync(),
      Directory(path.join(packagesDir.path, 'package2'))..createSync(),
      Directory(path.join(packagesDir.path, 'package3'))..createSync(),
      Directory(path.join(packagesDir.path, 'package4'))..createSync(),
    };

    // +1 for current dir (root project)
    callCount = packages.length + 1;

    File(path.join(packagesDir.path, 'package1', 'pubspec.yaml')).createSync();
    File(path.join(packagesDir.path, 'package2', 'pubspec.yaml')).createSync();
    File(path.join(packagesDir.path, 'package3', 'pubspec.yaml')).createSync();
    File(path.join(packagesDir.path, 'package4', 'pubspec.yaml')).createSync();

    when(mockProcess.exitCode).thenAnswer((_) async => ProceessInfo.exitCode);
    when(mockProcess.pid).thenReturn(ProceessInfo.pid);
    when(mockProcess.stdout).thenAnswer((_) => Stream<List<int>>.fromIterable([
          utf8.encode(ProceessInfo.stdout),
        ]));
    when(mockProcess.stderr).thenAnswer((_) => Stream<List<int>>.fromIterable([
          utf8.encode(ProceessInfo.stderr),
        ]));
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  group('Success Cases', () {
    test(
      'should run command successfully and return ${ExitCode.success.code}.',
      () async {
        // Arrange
        when(mockIProjectChecker.checkInRootProject()).thenAnswer(
          (_) async => right(true),
        );
        when(mockFileManager.findPackages(any))
            .thenAnswer((_) async => Right(packages));

        when(mockIMagicCommandStrategy.runCommand(any)).thenAnswer(
          (_) async => right(mockProcess),
        );

        when(mockFileManager.readYaml(any)).thenAnswer(
          (_) async => Right(
            {'name': 'package_name'},
          ),
        );

        // Act
        final result = await sut.launch(
          magicCommandStrategy: mockIMagicCommandStrategy,
        );

        // Assert
        expect(result, equals(0));

        verify(mockIProjectChecker.checkInRootProject()).called(1);
        verifyNoMoreInteractions(mockIProjectChecker);

        verify(mockFileManager.findPackages(any)).called(1);
        verify(mockFileManager.readYaml(any)).called(callCount);
        verifyNoMoreInteractions(mockFileManager);

        verify(mockIMagicCommandStrategy.runCommand(any)).called(callCount);
        verifyNoMoreInteractions(mockIMagicCommandStrategy);

        verify(mockProcess.stdout).called(callCount);
        verify(mockProcess.stderr).called(callCount);
        verify(mockProcess.pid).called(callCount * 2);
        verifyNoMoreInteractions(mockProcess);

        verify(
          mockIProcessLogger.stderr(
            processId: ProceessInfo.pid,
            processName: ProceessInfo.packageName,
            stderr: ProceessInfo.stderr,
          ),
        ).called(callCount);

        verify(
          mockIProcessLogger.stdout(
            processId: ProceessInfo.pid,
            processName: ProceessInfo.packageName,
            stdout: ProceessInfo.stdout,
          ),
        ).called(callCount);
        verifyNoMoreInteractions(mockIProcessLogger);

        verifyZeroInteractions(mockILogger);
      },
    );
    test(
      'should run command successfully and print pid when readYaml return Left and return ${ExitCode.success.code}.',
      () async {
        // Arrange
        when(mockIProjectChecker.checkInRootProject()).thenAnswer(
          (_) async => right(true),
        );
        when(mockFileManager.findPackages(any))
            .thenAnswer((_) async => Right(packages));

        when(mockIMagicCommandStrategy.runCommand(any)).thenAnswer(
          (_) async => right(mockProcess),
        );

        when(mockFileManager.readYaml(any)).thenAnswer(
          (_) async => Left(FileManagerFailure.unknown('')),
        );

        // Act
        final result = await sut.launch(
          magicCommandStrategy: mockIMagicCommandStrategy,
        );
        // Assert
        expect(result, equals(0));

        verify(mockIProjectChecker.checkInRootProject()).called(1);
        verifyNoMoreInteractions(mockIProjectChecker);

        verify(mockFileManager.findPackages(any)).called(1);
        verify(mockFileManager.readYaml(any)).called(callCount);
        verifyNoMoreInteractions(mockFileManager);

        verify(mockIMagicCommandStrategy.runCommand(any)).called(callCount);
        verifyNoMoreInteractions(mockIMagicCommandStrategy);

        verify(mockProcess.stdout).called(callCount);
        verify(mockProcess.stderr).called(callCount);
        verify(mockProcess.pid).called(callCount * 3);
        verifyNoMoreInteractions(mockProcess);

        verify(
          mockIProcessLogger.stderr(
            processId: ProceessInfo.pid,
            processName: ProceessInfo.pid.toString(),
            stderr: ProceessInfo.stderr,
          ),
        ).called(callCount);

        verify(
          mockIProcessLogger.stdout(
            processId: ProceessInfo.pid,
            processName: ProceessInfo.pid.toString(),
            stdout: ProceessInfo.stdout,
          ),
        ).called(callCount);
        verifyNoMoreInteractions(mockIProcessLogger);

        verifyZeroInteractions(mockILogger);
      },
    );
    test(
      'should return ${ExitCode.success.code} and print error in log when command return Left.',
      () async {
        // Arrange
        when(mockIProjectChecker.checkInRootProject()).thenAnswer(
          (_) async => right(true),
        );
        when(mockFileManager.findPackages(any))
            .thenAnswer((_) async => Right(packages));

        when(mockIMagicCommandStrategy.runCommand(any)).thenAnswer(
          (_) async => left(CliFailure.directoryNotFound()),
        );

        // Act
        final result = await sut.launch(
          magicCommandStrategy: mockIMagicCommandStrategy,
        );
        // Assert
        expect(result, equals(0));

        verify(mockIProjectChecker.checkInRootProject()).called(1);
        verifyNoMoreInteractions(mockIProjectChecker);

        verify(mockFileManager.findPackages(any)).called(1);
        verifyNoMoreInteractions(mockFileManager);

        verify(mockIMagicCommandStrategy.runCommand(any)).called(callCount);
        verifyNoMoreInteractions(mockIMagicCommandStrategy);

        verify(mockILogger.error(LoggerMessage.directoryNotFound))
            .called(callCount);
        verifyNoMoreInteractions(mockILogger);
      },
    );
    test(
      'should run command successfully and return ${ExitCode.success.code} and verify when use custom filter packages and add current dir when pass in filter.',
      () async {
        // Arrange
        when(mockIProjectChecker.checkInRootProject()).thenAnswer(
          (_) async => right(true),
        );
        when(mockFileManager.findPackages(
          any,
          where: anyNamed('where'),
        )).thenAnswer((_) async => Right(packages));

        when(mockIMagicCommandStrategy.runCommand(any)).thenAnswer(
          (_) async => right(mockProcess),
        );

        when(mockFileManager.readYaml(any)).thenAnswer(
          (_) async => Right(
            {'name': 'package_name'},
          ),
        );

        // Act
        final result = await sut.launch(
          magicCommandStrategy: mockIMagicCommandStrategy,
          packageWhere: (_) async => true,
        );

        // Assert
        expect(result, equals(0));
        verify(mockFileManager.findPackages(any, where: anyNamed('where')))
            .called(1);

        verify(mockFileManager.readYaml(any)).called(callCount);
        verifyNoMoreInteractions(mockFileManager);

        verify(mockIProjectChecker.checkInRootProject()).called(1);
        verifyNoMoreInteractions(mockIProjectChecker);

        verify(mockIMagicCommandStrategy.runCommand(any)).called(callCount);
        verifyNoMoreInteractions(mockIMagicCommandStrategy);

        verify(mockProcess.stdout).called(callCount);
        verify(mockProcess.stderr).called(callCount);
        verify(mockProcess.pid).called(callCount * 2);
        verifyNoMoreInteractions(mockProcess);

        verify(
          mockIProcessLogger.stderr(
            processId: ProceessInfo.pid,
            processName: ProceessInfo.packageName,
            stderr: ProceessInfo.stderr,
          ),
        ).called(callCount);

        verify(
          mockIProcessLogger.stdout(
            processId: ProceessInfo.pid,
            processName: ProceessInfo.packageName,
            stdout: ProceessInfo.stdout,
          ),
        ).called(callCount);
        verifyNoMoreInteractions(mockIProcessLogger);

        verifyZeroInteractions(mockILogger);
      },
    );
  });

  group('Failure Cases', () {
    test(
      'should return ${ExitCode.unavailable.code} and print error when checkInRootProject retrun Left<$ProjectCheckerFailureUnknown>.',
      () async {
        // Arrange
        final errorMessage = 'Error Message';
        when(mockIProjectChecker.checkInRootProject()).thenAnswer(
          (_) async => left(ProjectCheckerFailureUnknown(errorMessage)),
        );
        when(mockILogger.error(errorMessage)).thenReturn(null);

        // Act
        final result = await sut.launch(
          magicCommandStrategy: mockIMagicCommandStrategy,
        );
        // Assert
        expect(result, equals(ExitCode.unavailable.code));

        verify(mockIProjectChecker.checkInRootProject()).called(1);
        verify(mockILogger.error(errorMessage)).called(1);

        verifyNoMoreInteractions(mockIProjectChecker);
        verifyNoMoreInteractions(mockILogger);
      },
    );
    test(
      'should return ${ExitCode.noInput.code} and print error when checkInRootProject retrun Right<false>.',
      () async {
        // Arrange
        when(mockIProjectChecker.checkInRootProject()).thenAnswer(
          (_) async => right(false),
        );
        when(mockILogger.error(LoggerMessage.youAreNotInRootProject))
            .thenReturn(null);

        // Act
        final result = await sut.launch(
          magicCommandStrategy: mockIMagicCommandStrategy,
        );

        // Assert
        expect(result, equals(ExitCode.noInput.code));

        verify(mockIProjectChecker.checkInRootProject()).called(1);
        verify(mockILogger.error(LoggerMessage.youAreNotInRootProject))
            .called(1);

        verifyNoMoreInteractions(mockIProjectChecker);
        verifyNoMoreInteractions(mockILogger);
      },
    );
    test(
      'should return ${ExitCode.noInput.code} and print error when findPackages return Left<$FileManagerFailureDirNotFound>.',
      () async {
        // Arrange
        when(mockIProjectChecker.checkInRootProject()).thenAnswer(
          (_) async => right(true),
        );
        when(mockILogger.error(LoggerMessage.dirNotFound(tempDir.path)))
            .thenReturn(null);

        when(mockFileManager.findPackages(any)).thenAnswer(
          (_) async => left(FileManagerFailureDirNotFound()),
        );

        // Act
        final result = await sut.launch(
          magicCommandStrategy: mockIMagicCommandStrategy,
        );

        // Assert
        expect(result, equals(ExitCode.noInput.code));

        verify(mockIProjectChecker.checkInRootProject()).called(1);
        verifyNoMoreInteractions(mockIProjectChecker);

        verify(mockFileManager.findPackages(any)).called(1);
        verifyNoMoreInteractions(mockFileManager);

        verify(mockILogger.error(LoggerMessage.dirNotFound(packagesDir.path)))
            .called(1);
        verifyNoMoreInteractions(mockILogger);
      },
    );
    test(
      'should return ${ExitCode.unavailable.code} and print error when findPackages return Left<$FileManagerFailureUnknown>.',
      () async {
        // Arrange
        final errorMessage = 'Error Message';
        when(mockIProjectChecker.checkInRootProject()).thenAnswer(
          (_) async => right(true),
        );
        when(mockILogger.error(errorMessage)).thenReturn(null);

        when(mockFileManager.findPackages(any)).thenAnswer(
          (_) async => left(FileManagerFailure.unknown(errorMessage)),
        );

        // Act
        final result = await sut.launch(
          magicCommandStrategy: mockIMagicCommandStrategy,
        );

        // Assert
        expect(result, equals(ExitCode.unavailable.code));

        verify(mockIProjectChecker.checkInRootProject()).called(1);
        verifyNoMoreInteractions(mockIProjectChecker);

        verify(mockFileManager.findPackages(any)).called(1);
        verifyNoMoreInteractions(mockFileManager);

        verify(mockILogger.error(errorMessage)).called(1);
        verifyNoMoreInteractions(mockILogger);
      },
    );
    test(
      'should return ${ExitCode.unavailable.code} and print error when findPackages return Left<orElse>.',
      () async {
        // Arrange
        when(mockIProjectChecker.checkInRootProject()).thenAnswer(
          (_) async => right(true),
        );
        when(mockILogger.error(LoggerMessage.somethingWentWrong))
            .thenReturn(null);

        when(mockFileManager.findPackages(any)).thenAnswer(
          (_) async => left(FileManagerFailure.fileNotFound()),
        );

        // Act
        final result = await sut.launch(
          magicCommandStrategy: mockIMagicCommandStrategy,
        );

        // Assert
        expect(result, equals(ExitCode.unavailable.code));

        verify(mockIProjectChecker.checkInRootProject()).called(1);
        verifyNoMoreInteractions(mockIProjectChecker);

        verify(mockFileManager.findPackages(any)).called(1);
        verifyNoMoreInteractions(mockFileManager);

        verify(mockILogger.error(LoggerMessage.somethingWentWrong)).called(1);
        verifyNoMoreInteractions(mockILogger);
      },
    );
    test(
      'should return ${ExitCode.noInput.code} and print error when directory is empty.',
      () async {
        // Arrange
        when(mockIProjectChecker.checkInRootProject()).thenAnswer(
          (_) async => right(true),
        );
        when(mockILogger.error(LoggerMessage.noPackagesToProcess))
            .thenReturn(null);

        when(mockFileManager.findPackages(
          any,
          where: anyNamed('where'),
        )).thenAnswer(
          (_) async => right({}),
        );

        // Act
        final result = await sut.launch(
            magicCommandStrategy: mockIMagicCommandStrategy,
            packageWhere: (dir) async => false);

        // Assert
        expect(result, equals(ExitCode.noInput.code));

        verify(mockIProjectChecker.checkInRootProject()).called(1);
        verifyNoMoreInteractions(mockIProjectChecker);

        verify(mockFileManager.findPackages(any, where: anyNamed('where')))
            .called(1);
        verifyNoMoreInteractions(mockFileManager);

        verify(mockILogger.error(LoggerMessage.noPackagesToProcess)).called(1);
        verifyNoMoreInteractions(mockILogger);
      },
    );
  });
}
