import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:presto_cli/src/logger.dart';
import 'package:presto_cli/src/package_manager.dart';

class MagicRunnerCommand extends Command {
  MagicRunnerCommand({
    required IPackageManager packageManager,
    required IFileManager fileManager,
    required ILogger logger,
  })  : _packageManager = packageManager,
        _fileManager = fileManager,
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

  final IPackageManager _packageManager;
  final IFileManager _fileManager;
  final ILogger _logger;

  @override
  String get name => 'magic_runner';

  @override
  String get description =>
      'Generate files for all packages that depend on the build runner in the current/subdirectory';

  @override
  FutureOr? run() async {
    final pubspecFile = File(join(Directory.current.path, 'pubspec.yaml'));
    final readYamlResult = await _fileManager.readYaml(pubspecFile);

    if (readYamlResult.isLeft()) {
      readYamlResult.leftMap((failure) {
        failure.map(
          fileNotFound: (value) => _logger.error('pubspec.yaml not found.'),
          unknown: (value) => _logger.error(value.toString()),
        );
        exit(1);
      });
    }

    final yaml = readYamlResult.getOrElse(() => {});

    final String packageName = yaml['name'];

    if (packageName != 'prestoeat') {
      _logger.error('You are not in the root project.');
      exit(1);
    }

    _logger.info('You are in the root project.');
    exit(0);

    // check user in root project.
    //    - try read pubspec.yaml.
    //    - check project name is presto eat.

    // if user not in root project, exit.

    // find all packages in project [./packages_dir] has build_runner in pubspec.

    // run build_runner for each package.

    // Last Steps:
    // make parallel process for each package.
    // handle logs.

    // Setup
    final List<String> execludes = [];

    if (argResults != null && argResults!.wasParsed('execludes')) {
      execludes.addAll(argResults?['execludes']);
    }

    final isDeletingConflicting =
        argResults?.wasParsed('delete-conflicting-outputs') ?? false;

    final dirs = await _packageManager.findPackages(dir: Directory.current);

    // - filter files to need generate.
    final packagesInfo = await _packageManager.packagesGenerateInfo(dirs: dirs);

    packagesInfo.removeWhere((info) => execludes.contains(info.packageName));

    if (packagesInfo.isEmpty) {
      _logger.warn('No packages found to generate.');
      exit(0);
    } else {
      _logger.info('Find (${packagesInfo.length}) packages to generate.');
    }

    // - make build.yaml files
    // await _packageManager.makeBuildYaml(
    //   packagesDirs: packagesInfo.map((e) => e.dir).toList(),
    // );

    // - generate each package has build runner.
    final List<Future> jobs = [];
    for (GenerateInfo info in packagesInfo) {
      if (info.buildRunner) {
        final dir = info.dir;
        final arguments = ['pub', 'run', 'build_runner', 'build'];
        if (isDeletingConflicting) {
          arguments.add('--delete-conflicting-outputs');
        }
        final process = await Process.start(
          'flutter',
          arguments,
          workingDirectory: dir,
        );

        process.stdout.transform(utf8.decoder).listen((data) {
          print(data);
        });

        process.stderr.transform(utf8.decoder).listen((data) {
          print(data);
        });

        jobs.add(process.exitCode);
      }
    }

    await Future.wait(jobs);
  }
}
