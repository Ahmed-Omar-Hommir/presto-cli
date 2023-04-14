import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:file/file.dart' as file;
import 'package:file/local.dart';
import 'package:yaml/yaml.dart';

import 'package:args/command_runner.dart';

class FindPackagesCommand extends Command {
  FindPackagesCommand() {
    addSubcommand(ListPackagesCommand());
    addSubcommand(CreatePackagesCommand());
    addSubcommand(PubGetPackagesCommand());
    addSubcommand(BuildRunnerPackagesComand());
  }
  @override
  String get name => 'packages';

  @override
  String get description => 'Manage All Packages in Project.';
}

class BuildRunnerPackagesComand extends Command {
  BuildRunnerPackagesComand() : _packagesManager = PackageManager() {
    argParser.addOption(
      'target',
      allowed: [
        'current',
        'all',
      ],
      defaultsTo: 'current',
      abbr: 't',
    );
    argParser.addFlag(
      'delete-conflicting-outputs',
      abbr: 'd',
    );
  }
  final IPackagesManager _packagesManager;

  @override
  String get description => 'generate command in packages';

  @override
  String get name => 'build-runner';

  @override
  FutureOr? run() async {
    final args = argResults;

    String target = 'current';
    if (args != null && args.wasParsed('target')) {
      target = args['target'];
      print(target);
    }

    if (target == 'current') {
      final process = await Process.start(
        'flutter',
        ['pub', 'run', 'build_runner', 'build', '-d'],
      );

      process.stdout
          .transform(utf8.decoder)
          .listen((data) => print(data.trim()));
      process.stderr
          .transform(utf8.decoder)
          .listen((data) => stderr.writeln(data.trim()));

      final exitCode = await process.exitCode;
      exit(0);
    }

    if (target == 'all') {
      final result = await _packagesManager.findAllPackages();

      final packages = result.where((package) => package.hasBuildRunner);

      final List<Future<int>> exitCode = [];

      for (final package in packages) {
        final process = await Process.start(
          'flutter',
          ['pub', 'run', 'build_runner', 'build', '-d'],
          workingDirectory: package.path,
        );

        process.stdout
            .transform(utf8.decoder)
            .listen((data) => print(data.trim()));
        process.stderr
            .transform(utf8.decoder)
            .listen((data) => stderr.writeln(data.trim()));

        exitCode.add(process.exitCode);
      }

      print("Running...");
      await Future.wait(exitCode);
      print("Done");

      exit(0);
    }
  }
}

class ListPackagesCommand extends Command {
  ListPackagesCommand() : _packagesManager = PackageManager() {
    argParser.addFlag('details', abbr: 'd');
  }
  @override
  String get description => "Show all packages in the project.";

  @override
  String get name => 'list';

  @override
  List<String> get aliases => ['l'];

  final IPackagesManager _packagesManager;

  @override
  FutureOr<void>? run() async {
    final args = argResults;
    final packagesInfo = await _packagesManager.findAllPackages();

    if (packagesInfo.isNotEmpty) {
      if (args != null && args.wasParsed('details')) {
        for (PackageInformation info in packagesInfo) {
          print("=" * 40);
          print("Package Name: ${info.name}");
          print("Path: ${info.path}");
          print("Localization: ${info.hasLocalization}");
          print("Build Runner: ${info.hasBuildRunner}");
          print("=" * 40);
        }
      } else {
        for (PackageInformation info in packagesInfo) {
          print(info.name);
        }
      }
    } else {
      print('No Packages Found.');
    }
  }
}

class PubGetPackagesCommand extends Command {
  PubGetPackagesCommand() {
    argParser.addFlag('all', abbr: 'a');
  }

  @override
  String get description => "Get dependencies for packages in project.";

  @override
  String get name => 'get';

  @override
  FutureOr? run() async {
    final process = await Process.start('flutter', ['pub', 'get']);

    // Listen to the stdout and stderr streams and print their contents.
    process.stdout.transform(utf8.decoder).listen((data) => print(data.trim()));
    process.stderr
        .transform(utf8.decoder)
        .listen((data) => stderr.writeln(data.trim()));

    final exitCode = await process.exitCode;

    if (exitCode == 0) {
      print('"flutter pub get" completed successfully.');
    } else {
      stderr.writeln('"flutter pub get" failed with exit code $exitCode.');
    }
  }
}

class PackageInformation {
  const PackageInformation({
    required this.name,
    required this.path,
    required this.hasLocalization,
    required this.hasBuildRunner,
  });
  final String name;
  final String path;
  final bool hasLocalization;
  final bool hasBuildRunner;
}

class CreatePackagesCommand extends Command {
  @override
  String get description => "Create New Package.";

  @override
  String get name => 'create';

  @override
  List<String> get aliases => ['c'];

  @override
  void run() {
    print("=" * 40);
    print('create a new package');
    print("=" * 40);
  }
}

abstract class IPackagesManager {
  Future<List<PackageInformation>> findAllPackages();
  void findPackageByName(String packageName);
  void pubGetByName(String packageName);
  void pubGetAllPackages();
  void pubGetByPackageName(String packageName);
  void buildRunnerAllPackages();
  void buildRunnerByPackageName(String packageName);
  void genL10NAllPackages();
  void genL10NByPackageName(String packageName);
}

class PackageManager implements IPackagesManager {
  @override
  Future<List<PackageInformation>> findAllPackages() async {
    final startingDirectory = Directory('./');
    final List<PackageInformation> packagesInfo = [];

    await for (FileSystemEntity entity
        in startingDirectory.list(recursive: true, followLinks: false)) {
      if (entity is File && entity.path.endsWith('/pubspec.yaml')) {
        const file.FileSystem fs = LocalFileSystem();
        final String yamlContent = await fs.file(entity.path).readAsString();
        final YamlMap yamlMap = loadYaml(yamlContent);

        final hasBuildRunner =
            yamlMap['dev_dependencies'].containsKey('build_runner') ||
                yamlMap['dependencies'].containsKey('build_runner');

        final packagePath = entity.path.replaceAll('pubspec.yaml', '');

        final hasLocalization = File('${packagePath}l10n.yaml').existsSync();

        packagesInfo.add(
          PackageInformation(
            name: yamlMap['name'],
            path: packagePath,
            hasBuildRunner: hasBuildRunner,
            hasLocalization: hasLocalization,
          ),
        );
      }
    }

    return packagesInfo;
  }

  @override
  void buildRunnerAllPackages() async {
    final packages = await findAllPackages();

    final output = packages.where((package) => package.hasBuildRunner);

    for (PackageInformation package in output) {
      print(package.name);
    }
  }

  @override
  void buildRunnerByPackageName(String packageName) {
    // TODO: implement buildRunnerByPackageName
  }

  @override
  void findPackageByName(String packageName) {
    // TODO: implement findPackageByName
  }

  @override
  void genL10NAllPackages() {
    // TODO: implement genL10NAllPackages
  }

  @override
  void genL10NByPackageName(String packageName) {
    // TODO: implement genL10NByPackageName
  }

  @override
  void pubGetAllPackages() {
    // TODO: implement pubGetAllPackages
  }

  @override
  void pubGetByName(String packageName) {
    // TODO: implement pubGetByName
  }

  @override
  void pubGetByPackageName(String packageName) {
    // TODO: implement pubGetByPackageName
  }
}
