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
import 'package:presto_cli/src/package_manager.dart';

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
                (response) {
                  _logger.info(response.output);
                },
              );
            }
            return ExitCode.success.code;
          },
        );
      },
    );

    // final List<Future> processes = [];
    // int processCompleted = 0;

    // final buildRunnerProgress = _logger.progress(
    //     'Running build_runner: ${processCompleted / processes.length}%');

    // for (Directory dir in packagesDir) {
    //   processes.add(_flutterCli
    //       .buildRunner(
    //     dir,
    //     deleteConflictingOutputs: true,
    //   )
    //       .then((value) {
    //     value.fold(
    //       (l) => print(l),
    //       (r) {
    //         print(dir.path);
    //         print(r.output);
    //       },
    //     );
    //     processCompleted++;
    //     buildRunnerProgress.update(
    //         'Running build_runner: ${processCompleted / processes.length}%');
    //   }));
    // }

    // await Future.wait(processes);
    // buildRunnerProgress.complete('Running build_runner completed.');

    // return ExitCode.success.code;

    //// check user in root project.
    ////    - try read pubspec.yaml.
    ////    - check project name is presto eat.

    //// if user not in root project, exit.

    // find all packages in project [./packages_dir] has build_runner in pubspec.

    // run build_runner for each package.

    // Last Steps:
    // make parallel process for each package.
    // handle logs.

    // Setup
    // final List<String> execludes = [];

    // if (argResults != null && argResults!.wasParsed('execludes')) {
    //   execludes.addAll(argResults?['execludes']);
    // }

    // final isDeletingConflicting =
    //     argResults?.wasParsed('delete-conflicting-outputs') ?? false;

    // final dirs = await _packageManager.findPackages(dir: Directory.current);

    // // - filter files to need generate.
    // final packagesInfo = await _packageManager.packagesGenerateInfo(dirs: dirs);

    // packagesInfo.removeWhere((info) => execludes.contains(info.packageName));

    // if (packagesInfo.isEmpty) {
    //   _logger.warn('No packages found to generate.');
    //   exit(0);
    // } else {
    //   _logger.info('Find (${packagesInfo.length}) packages to generate.');
    // }

    // // - make build.yaml files
    // // await _packageManager.makeBuildYaml(
    // //   packagesDirs: packagesInfo.map((e) => e.dir).toList(),
    // // );

    // // - generate each package has build runner.
    // final List<Future> jobs = [];
    // for (GenerateInfo info in packagesInfo) {
    //   if (info.buildRunner) {
    //     final dir = info.dir;
    //     final arguments = ['pub', 'run', 'build_runner', 'build'];
    //     if (isDeletingConflicting) {
    //       arguments.add('--delete-conflicting-outputs');
    //     }
    //     final process = await Process.start(
    //       'flutter',
    //       arguments,
    //       workingDirectory: dir,
    //     );

    //     process.stdout.transform(utf8.decoder).listen((data) {
    //       print(data);
    //     });

    //     process.stderr.transform(utf8.decoder).listen((data) {
    //       print(data);
    //     });

    //     jobs.add(process.exitCode);
    //   }
    // }

    // await Future.wait(jobs);
  }
}

abstract class LoggerMessage {
  static const String youAreNotInRootProject =
      'You are not in the root project.';
  static const String somethingWentWrong = 'Something went wrong.';
  static const String directoryNotFound = 'Directory not found.';
}

class ParallelProcess {}
