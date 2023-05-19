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
    @visibleForTesting Directory? currentDir,
  })  : _fileManager = fileManager,
        _flutterCli = flutterCli,
        _currentDir = currentDir ?? Directory.current,
        _logger = logger {
    argParser.addFlag(
      'delete-conflicting-outputs',
      help:
          'it tells the build system to delete any generated output files that already exist and have conflicting content before starting a new build. This can be useful to ensure that the generated files are up-to-date and consistent with the current build configuration.',
      abbr: 'd',
      negatable: false,
    );

    argParser.addMultiOption(
      'execludes',
      help: 'Ignore the package for the generate file using the package name.',
    );
  }

  final IFileManager _fileManager;
  final ILogger _logger;
  final IFlutterCLI _flutterCli;
  final Directory _currentDir;

  @override
  String get name => 'magic_runner';

  @override
  String get description =>
      'Generate files for all packages that depend on the build runner in the current/subdirectory';

  // Todo: make this method on seperated class, becouse it's shared between magic_runner_command and make_command

  Future<Either<ExitCode, None>> _checkInRootProject() async {
    final pubspecFile = File(join(Directory.current.path, 'pubspec.yaml'));

    final readYamlResult = await _fileManager.readYaml(pubspecFile.path);

    return readYamlResult.fold(
      (failure) => Left(
        failure.maybeMap(
          fileNotFound: (value) {
            _logger.error(LoggerMessage.youAreNotInRootProject);
            return ExitCode.noInput;
          },
          unknown: (value) {
            _logger.error(value.toString());
            return ExitCode.unavailable;
          },
          orElse: () => ExitCode.unavailable,
        ),
      ),
      (fileContent) {
        final String packageName = fileContent['name'];
        if (packageName != 'prestoeat') {
          _logger.error(LoggerMessage.youAreNotInRootProject);
          return Left(ExitCode.noInput);
        }
        return Right(None());
      },
    );
  }

  // Todo: make this method on seperated class, becouse it's shared between magic_runner_command and make_command

  Future<Either<ExitCode, Set<Directory>>> _getPackagesToGenerate() async {
    final packagesResult = await _fileManager.findPackages(
      Directory(join(Directory.current.path, 'packages')),
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

  @override
  Future<int> run() async {
    final result = await _checkInRootProject();

    return await result.fold(
      (exitCode) => exitCode.code,
      (_) async {
        final packagesResult = await _getPackagesToGenerate();
        return await packagesResult.fold(
          (failure) => failure.code,
          (packagesDir) async {
            for (Directory dir in packagesDir) {
              final result = await _flutterCli.buildRunner(dir);
              await result.fold(
                (failure) {
                  _logger.error(
                    failure.maybeMap(
                      directoryNotFound: (_) => LoggerMessage.directoryNotFound,
                      unknown: (value) => value.e.toString(),
                      orElse: () => LoggerMessage.somethingWentWrong,
                    ),
                  );
                },
                (response) async {
                  response.stdout.transform(utf8.decoder).listen((event) {
                    _logger.info(event);
                  });
                  response.stderr.transform(utf8.decoder).listen((event) {
                    _logger.info(event);
                  });
                  await response.exitCode;
                },
              );
            }
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
