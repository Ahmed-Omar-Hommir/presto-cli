import 'dart:io';
import 'package:dart_console/dart_console.dart';
import 'package:dartz/dartz.dart';
import 'package:json2yaml/json2yaml.dart';
import 'package:yaml/yaml.dart';

abstract class IPackageManager {
  Future<Either<None, None>> createNewPackage({required String packageName});

  Future<void> pubAdd({
    required String packagePath,
    required List<String> dependencies,
  });

  Future<void> addDependencies({
    required String packagePath,
    required Map<String, dynamic> dependencies,
  });

  Future<void> addDevDependencies({
    required String packagePath,
    required Map<String, dynamic> dependencies,
  });

  Future<void> getL10N({required String packagePath});
}

class PackageManager implements IPackageManager {
  @override
  Future<Either<None, None>> createNewPackage({
    required String packageName,
  }) async {
    try {
      final console = Console();
      console.writeLine('Creating $packageName Package...');
      final process = await Process.start('flutter', [
        'create',
        '--template=package',
        packageName,
      ]);
      await process.exitCode;
      return right(None());
    } catch (_) {
      return left(None());
    }
  }

  @override
  Future<void> pubAdd({
    required String packagePath,
    required List<String> dependencies,
  }) async {
    final proccess = await Process.start(
      'flutter',
      ['pub', 'add', ...dependencies],
      workingDirectory: packagePath,
    );

    await proccess.exitCode;
  }

  @override
  Future<void> addDependencies({
    required String packagePath,
    required Map<String, dynamic> dependencies,
  }) async {
    final pubspecFile = File('$packagePath/pubspec.yaml');
    final pubspecContent = await pubspecFile.readAsString();

    // Parse the YAML content
    final pubspecYaml = loadYaml(pubspecContent);
    final pubspecMap = yamlMapToDartMap(pubspecYaml);

    Map<String, dynamic> updatedDependencies = pubspecMap['dependencies'];

    for (MapEntry<String, dynamic> entrie in dependencies.entries) {
      if (pubspecMap['dependencies']?[entrie.key] == null) {
        updatedDependencies.addEntries([entrie]);
      }
    }

    final Map<String, dynamic> updatedPubspecYaml = {
      ...pubspecMap,
      'dependencies': updatedDependencies,
    };

    final yaml = json2yaml(updatedPubspecYaml);

    await pubspecFile.writeAsString(yaml);
  }

  @override
  Future<void> addDevDependencies({
    required String packagePath,
    required Map<String, dynamic> dependencies,
  }) async {}

  @override
  Future<void> getL10N({required String packagePath}) async {
    final proccess = await Process.start(
      'flutter',
      ['gen-l10n'],
      workingDirectory: packagePath,
    );

    await proccess.exitCode;
  }
}

String convertToCamelCase(String input) {
  return input
      .split('_')
      .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
      .join('');
}

Map<String, dynamic> yamlMapToDartMap(YamlMap yamlMap) {
  return yamlMap.map((key, value) => MapEntry<String, dynamic>(
      key, value is YamlMap ? yamlMapToDartMap(value) : value));
}

class AddPackage {
  AddPackage({
    required this.packageName,
    this.isActive = false,
  });
  final String packageName;
  final bool isActive;
}
