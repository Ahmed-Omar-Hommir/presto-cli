import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:presto_cli/src/commands/magic/commands/magic_runner_command.dart';
import 'package:presto_cli/src/logger.dart';

import 'magic_lancher_strategies.dart';

abstract class IMagicLauncher {
  Future<int> launch({
    List<Directory> packages = const [],
    required IMagicCommandStrategy magicCommandStrategy,
    Future<bool> Function(Directory dir)? packageWhere,
  });
}

class MagicLauncher implements IMagicLauncher {
  const MagicLauncher({
    @visibleForTesting IProjectChecker projectChecker = const ProjectChecker(
      fileManager: FileManager(),
    ),
    required IFileManager fileManager,
    required ILogger logger,
    required ITasksRunner<Either<CliFailure, Process>> tasksRunner,
    required IProcessLogger processLogger,
    @visibleForTesting IDirectoryFactory? directoryFactory,
  })  : _logger = logger,
        _projectChecker = projectChecker,
        _tasksRunner = tasksRunner,
        _processLogger = processLogger,
        _directoryFactory = directoryFactory ?? const DirectoryFactory(),
        _fileManager = fileManager;

  final IProjectChecker _projectChecker;
  final ILogger _logger;
  final IFileManager _fileManager;
  final ITasksRunner<Either<CliFailure, Process>> _tasksRunner;
  final IProcessLogger _processLogger;
  final IDirectoryFactory _directoryFactory;

  Future<Either<CliFailure, Process>> _task(
    Directory dir,
    IMagicCommandStrategy magicCommandStrategy,
  ) async {
    final result = await magicCommandStrategy.runCommand(dir);
    await result.fold(
      (failure) {
        final failureMessage = failure.maybeMap(
          directoryNotFound: (_) => LoggerMessage.directoryNotFound,
          unknown: (value) => value.e.toString(),
          orElse: () => LoggerMessage.somethingWentWrong,
        );

        _logger.error(failureMessage);
      },
      (process) async {
        final packageNameResult = await _fileManager.readYaml(
          join(dir.path, 'pubspec.yaml'),
        );

        final String processName = packageNameResult.fold(
          (_) => process.pid.toString(),
          (content) => content['name'],
        );

        process.stdout.transform(utf8.decoder).listen((stdout) {
          _processLogger.stdout(
            processId: process.pid,
            processName: processName,
            stdout: stdout,
          );
        });
        process.stderr.transform(utf8.decoder).listen((stderr) {
          _processLogger.stderr(
            processId: process.pid,
            processName: processName,
            stderr: stderr,
          );
        });
      },
    );
    return result;
  }

  @override
  Future<int> launch({
    List<Directory> packages = const [],
    required IMagicCommandStrategy magicCommandStrategy,
    Future<bool> Function(Directory dir)? packageWhere,
  }) async {
    final result = await _projectChecker.checkInRootProject();
    return await result.fold(
      (failure) => failure.map(unknown: (value) {
        _logger.error(value.e.toString());
        return ExitCode.unavailable.code;
      }),
      (isInRoot) async {
        if (!isInRoot) {
          _logger.error(LoggerMessage.youAreNotInRootProject);
          return ExitCode.noInput.code;
        }

        final targetDir =
            Directory(join(_directoryFactory.current.path, 'packages'));

        final Set<Directory> packagesDir = {};

        if (packages.isNotEmpty) {
          packagesDir.addAll(packages.toSet());
        } else {
          final packagesDirResult = await _fileManager.findPackages(
            targetDir,
            where: packageWhere,
          );

          int? errorCode = packagesDirResult.fold(
            (failure) => failure.maybeMap(
              dirNotFound: (value) {
                _logger.error(LoggerMessage.dirNotFound(targetDir.path));
                return ExitCode.noInput.code;
              },
              unknown: (value) {
                _logger.error(value.e.toString());
                return ExitCode.unavailable.code;
              },
              orElse: () {
                _logger.error(LoggerMessage.somethingWentWrong);
                return ExitCode.unavailable.code;
              },
            ),
            (packagesDirList) {
              packagesDir.addAll(packagesDirList);
              return null;
            },
          );

          if (errorCode != null) return errorCode;
        }

        if (packageWhere != null) {
          if (await packageWhere(_directoryFactory.current)) {
            packagesDir.add(_directoryFactory.current);
          }
        } else {
          packagesDir.add(_directoryFactory.current);
        }

        if (packagesDir.isEmpty) {
          _logger.error(LoggerMessage.noPackagesToProcess);
          return ExitCode.noInput.code;
        }

        await _tasksRunner.run(
          tasks: List.generate(
            packagesDir.length,
            (index) => () => _task(
                  packagesDir.elementAt(index),
                  magicCommandStrategy,
                ),
          ),
          concurrency: Platform.numberOfProcessors,
          resultWaiter: (value) {
            return value.fold(
              (_) => Future.value(),
              (process) => process.exitCode,
            );
          },
        );

        return ExitCode.success.code;
      },
    );
  }
}

abstract class IDirectoryFactory {
  Directory get current;
}

class DirectoryFactory implements IDirectoryFactory {
  const DirectoryFactory();
  @override
  Directory get current => Directory.current;
}
