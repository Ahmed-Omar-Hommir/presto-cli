import 'dart:io';

import 'package:path/path.dart';

void makeDartFiles(Directory dir) {
  final dira = Directory(join(dir.path, 'dir_a'));
  dira.createSync();
  final dirb = Directory(join(dir.path, 'dir_b'));
  dirb.createSync();

  for (var i = 0; i < 4; i++) {
    File(join(dir.path, 'file_$i.dart')).createSync();
    File(join(dira.path, 'file_$i.dart')).createSync();
    File(join(dirb.path, 'file_$i.dart')).createSync();
  }
}

List<String> dartFiles(Directory dir) {
  final path = dir.path;
  return [
    ...List.generate(4, (index) => join(path, 'file_$index.dart')),
    ...List.generate(4, (index) => join(path, 'dir_a', 'file_$index.dart')),
    ...List.generate(4, (index) => join(path, 'dir_b', 'file_$index.dart')),
  ]..sort();
}

Future<void> createTempPackage(
  Directory dir, {
  required String packageName,
  bool withLib = true,
  bool withPubspec = true,
}) async {
  final path = dir.path;
  final packageDir = Directory(join(path, packageName));
  packageDir.createSync();
  if (withPubspec) {
    await createPubspecFile(packageDir);
  }
  if (withLib) {
    Directory(join(packageDir.path, 'lib')).createSync();
  }
}

Future<void> createJsonFile(Directory dir) async {
  final jsonFile = File(join(dir.path, 'file.json'));
  await jsonFile.writeAsString(
    """
{
  "name": "presto",
  "description": "test package",
  "version": "0.0.0",
  "environment": {
    "sdk": ">=2.19.6 <3.0.0"
  },
  "dependencies": {
    "path": "^1.8.0",
    "freezed": "^2.3.2"
  },
  "dev_dependencies": {
    "lints": "^2.0.0",
    "test": "^1.21.0"
  }
}
  """,
  );
}

Future<void> createPubspecFile(Directory dir) async {
  final pubspecFile = File(join(dir.path, 'pubspec.yaml'));
  await pubspecFile.writeAsString(
    """
name: presto
description: test package
version: 0.0.0

environment:
  sdk: '>=2.19.6 <3.0.0'

dependencies:
  path: ^1.8.0
  freezed: ^2.3.2

dev_dependencies:
  lints: ^2.0.0
  test: ^1.21.0
  """,
  );
}
