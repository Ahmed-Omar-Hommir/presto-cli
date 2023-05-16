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

import 'magic_runner_command_test.mocks.dart';

@GenerateMocks([
  PackageManager,
  IFileManager,
  ILogger,
  IFlutterCLI,
])
void main() {
  late CommandRunner<int> sut;
  late MockPackageManager packageManager;
  late MockIFileManager fileManager;
  late MockILogger logger;
  late IFlutterCLI flutterCli;

  setUp(() {
    packageManager = MockPackageManager();
    fileManager = MockIFileManager();
    logger = MockILogger();
    flutterCli = MockIFlutterCLI();

    sut = CommandRunner<int>('test', 'test')
      ..addCommand(MagicRunnerCommand(
        flutterCli: flutterCli,
        packageManager: packageManager,
        fileManager: fileManager,
        logger: logger,
      ));
  });

  group('Success cases', () {
    test(
      'should return success code when command is executed successfully.',
      () async {
        // Arrange
        when(fileManager.readYaml(any)).thenAnswer(
          (_) async => Right({'name': 'prestoeat'}),
        );
        when(logger.error(any)).thenReturn(null);
        final Set<Directory> packages = {
          Directory('path_1'),
          Directory('path_2'),
          Directory('path_3'),
        };
        when(fileManager.findPackages(any)).thenAnswer(
          (_) async => Right(packages),
        );
        when(flutterCli.genBuildRunner(packagePath: "path_1")).thenAnswer(
          (_) async => right(ProcessResponse(
            stdout: 'stdout',
            stderr: 'stderr',
            exitCode: 0,
            pid: 1,
          )),
        );
        when(flutterCli.genBuildRunner(packagePath: "path_2")).thenAnswer(
          (_) async => right(ProcessResponse(
            stdout: 'stdout',
            stderr: 'stderr',
            exitCode: 0,
            pid: 1,
          )),
        );
        when(flutterCli.genBuildRunner(packagePath: "path_3")).thenAnswer(
          (_) async => right(ProcessResponse(
            stdout: 'stdout',
            stderr: 'stderr',
            exitCode: 0,
            pid: 1,
          )),
        );

        // Act
        final exitCode = await sut.run(['magic_runner']);

        // Assert
        expect(exitCode, ExitCode.success.code);
        verify(fileManager.readYaml(any)).called(1);
        verify(fileManager.findPackages(any)).called(1);
        verify(flutterCli.genBuildRunner(packagePath: "path_1")).called(1);
        verify(flutterCli.genBuildRunner(packagePath: "path_2")).called(1);
        verify(flutterCli.genBuildRunner(packagePath: "path_3")).called(1);
        verifyNoMoreInteractions(flutterCli);
        verifyNoMoreInteractions(fileManager);
        verifyZeroInteractions(logger);
      },
    );
  });

  group('Failure cases', () {
    test(
      'should print error and return noInput code when readYaml return $FileManagerFailureFileNotFound.',
      () async {
        // Arrange
        when(fileManager.readYaml(any)).thenAnswer(
          (_) async => Left(FileManagerFailure.fileNotFound()),
        );
        when(logger.error(any)).thenReturn(null);

        // Act
        final exitCode = await sut.run(['magic_runner']);

        // Assert
        expect(exitCode, ExitCode.noInput.code);
        verify(logger.error(any)).called(1);
        verifyNoMoreInteractions(logger);
      },
    );

    test(
      'should print error and return unavailable code when readYaml return $FileManagerFailureUnknown.',
      () async {
        // Arrange
        when(fileManager.readYaml(any)).thenAnswer(
          (_) async => Left(FileManagerFailure.unknown("Error")),
        );
        when(logger.error(any)).thenReturn(null);

        // Act
        final exitCode = await sut.run(['magic_runner']);

        // Assert
        expect(exitCode, ExitCode.unavailable.code);
        verify(logger.error(any)).called(1);
        verifyNoMoreInteractions(logger);
      },
    );

    test(
      'should print error and return noInput code if pubspec.yaml file is not found.',
      () async {
        // Arrange
        when(fileManager.readYaml(any)).thenAnswer(
          (_) async => Left(FileManagerFailure.fileNotFound()),
        );
        when(logger.error(any)).thenReturn(null);

        // Act
        final exitCode = await sut.run(['magic_runner']);

        // Assert
        expect(exitCode, ExitCode.noInput.code);
        verify(logger.error(any)).called(1);
        verifyNoMoreInteractions(logger);
      },
    );

    test(
      'should print error and return noInput code if package name is not match.',
      () async {
        // Arrange
        when(fileManager.readYaml(any)).thenAnswer(
          (_) async => Right({'name': 'not_match_package_name'}),
        );
        when(logger.error(any)).thenReturn(null);

        // Act
        final exitCode = await sut.run(['magic_runner']);

        // Assert
        expect(exitCode, ExitCode.noInput.code);
        verify(logger.error(any)).called(1);
        verifyNoMoreInteractions(logger);
      },
    );
  });
}
