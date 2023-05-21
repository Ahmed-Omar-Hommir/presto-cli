import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:presto_cli/src/logger.dart';

class MagicRunnerCommand extends Command<int> {
  MagicRunnerCommand({
    required IFileManager fileManager,
    required ILogger logger,
    required IFlutterCLI flutterCli,
    required IProcessLogger processLogger,
    required IProjectChecker projectChecker,
    required ITasksRunner tasksRunner,
    @visibleForTesting Directory? currentDir,
  })  : _fileManager = fileManager,
        _projectChecker = projectChecker,
        _tasksRunner = tasksRunner,
        _flutterCli = flutterCli,
        _processLogger = processLogger,
        _currentDir = currentDir ?? Directory.current,
        _logger = logger {
    argParser.addFlag(
      'delete-conflicting-outputs',
      help:
          'it tells the build system to delete any generated output files that already exist and have conflicting content before starting a new build. This can be useful to ensure that the generated files are up-to-date and consistent with the current build configuration.',
      abbr: 'd',
      negatable: false,
    );
  }

  final IProcessLogger _processLogger;
  final IFileManager _fileManager;
  final ILogger _logger;
  final IFlutterCLI _flutterCli;
  final Directory _currentDir;
  final IProjectChecker _projectChecker;
  final ITasksRunner _tasksRunner;

  @override
  String get name => 'magic_runner';

  @override
  String get description =>
      'Generate files for all packages that depend on the build runner in the current/subdirectory';

  Future<Either<ExitCode, Set<Directory>>> _getPackagesToGenerate() async {
    final packagesResult = await _fileManager.findPackages(
      Directory(join(Directory.current.path, 'packages')),
      where: (dir) async {
        final pubspecFile = File(join(dir.path, 'pubspec.yaml'));
        final contetnt = await pubspecFile.readAsString();
        return contetnt.contains('build_runner');
      },
    );

    return packagesResult.fold(
      (failure) {
        return Left(failure.maybeMap(
          dirNotFound: (_) {
            _logger.error(LoggerMessage.youAreNotInRootProject);
            return ExitCode.noInput;
          },
          unknown: (value) {
            _logger.error(value.e.toString());
            return ExitCode.unavailable;
          },
          orElse: () {
            _logger.error(LoggerMessage.somethingWentWrong);
            return ExitCode.unavailable;
          },
        ));
      },
      (dirs) {
        return Right({...dirs, _currentDir});
      },
    );
  }

  Future<Either<CliFailure, Process>> _buildRunnerTask(Directory dir) async {
    final result = await _flutterCli.buildRunner(
      dir,
      deleteConflictingOutputs: argResults?['delete-conflicting-outputs'],
    );
    result.fold(
      (failure) {
        _logger.error(
          failure.maybeMap(
            directoryNotFound: (_) => LoggerMessage.directoryNotFound,
            unknown: (value) => value.e.toString(),
            orElse: () => LoggerMessage.somethingWentWrong,
          ),
        );
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

  Future<void> _runBuildRunner(Set<Directory> directories) async {
    final tasks = List.generate(
      directories.length,
      (index) => () => _buildRunnerTask(directories.elementAt(index)),
    );

    await _tasksRunner.run(
      tasks: tasks,
      concurrency: Platform.numberOfProcessors,
      resultWaiter: (value) {
        if (value is Either<CliFailure, Process>) {
          return value.fold(
            (failure) => Future.value(),
            (process) => process.exitCode,
          );
        }
        return Future.value();
      },
    );
  }

  @override
  Future<int> run() async {
    final result = await _projectChecker.checkInRootProject();

    return await result.fold(
      (failure) => failure.map(
        unknown: (value) {
          _logger.error(value.e.toString());
          return ExitCode.unavailable.code;
        },
      ),
      (inRootProject) async {
        if (!inRootProject) {
          _logger.error(LoggerMessage.youAreNotInRootProject);
          return ExitCode.noInput.code;
        }

        final packagesResult = await _getPackagesToGenerate();

        return await packagesResult.fold(
          (failure) => failure.code,
          (packagesDir) async {
            await _runBuildRunner(packagesDir);
            return ExitCode.success.code;
          },
        );
      },
    );
  }
}

abstract class LoggerMessage {
  static const String youAreNotInRootProject =
      'You are not in the root project.';
  static const String somethingWentWrong = 'Something went wrong.';
  static const String directoryNotFound = 'Directory not found.';
}
