import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cli/commands/create/create.dart';
import 'package:cli/commands/packages_command.dart';

void main(List<String> args) async {
  final runner =
      CommandRunner('pacakges', 'Manage all packages in the project.')
        ..addCommand(FindPackagesCommand())
        ..addCommand(CreateCommand());

  await runner.run(args);
}

Future<void> _runFlutterPubGet() async {
  print('Running "flutter pub get"...');
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

Future<void> _findPackages() async {
  final startingDirectory = Directory('./');
  final boxDartFiles = <String>[];

  await for (FileSystemEntity entity
      in startingDirectory.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('/pubspec.yaml')) {
      boxDartFiles.add(entity.path);
    }
  }

  if (boxDartFiles.isNotEmpty) {
    for (String filePath in boxDartFiles) {
      print(filePath);
    }
  } else {
    print('No Packages Found.');
  }
}

abstract class FirstArguments {
  static const String greet = 'greet';
  static const String help = 'help';
  static const String pubGet = 'pub-get';
  static const String packages = 'packages';
}
