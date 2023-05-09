import 'dart:io';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:dartz/dartz.dart';
import 'package:json2yaml/json2yaml.dart';
import 'package:path/path.dart';
import 'package:presto_cli/src/package_manager.dart';

import 'build_yaml_failure.dart';

/// Generates a `build.yaml` file for a Dart package by analyzing the package's dependencies
/// and configuring builders based on the annotations found in the source code.

abstract class IBuildYamlGenerator {
  Future<Either<BuildYamlFailure, None>> genBuildYaml({
    /// [packagePath] is the relative path to the Dart package for which the `build.yaml` file will be generated.
    required String packagePath,
  });
}

// Todo: can reduce time by using cache for analysisContextCollection.

class BuildYamlGenerator implements IBuildYamlGenerator {
  BuildYamlGenerator({
    required IPackageManager packageManager,
  }) : _packageManager = packageManager;

  final IPackageManager _packageManager;

  /// The function performs the following steps:
  /// 1. Locates and reads the `pubspec.yaml` file.
  /// 2. Checks if the `build_runner` dependency is present.
  /// 3. Collects Dart files in the `lib` and `test` directories.
  /// 4. Creates an `AnalysisContextCollection` for analyzing the Dart files.
  /// 5. Processes the files to identify the annotations and the required builders.
  /// 6. Generates a `build.yaml` file with the necessary builder configurations.
  @override
  Future<Either<BuildYamlFailure, None>> genBuildYaml(
      {required String packagePath}) async {
    final pubspecFileResult = _findPubspecFile(packagePath);

    return await pubspecFileResult.fold(
      (failure) => left(failure),
      (pubspecFile) async {
        final pubspecContent = await _readPubspecContent(pubspecFile);

        if (!_checkBuildRunner(pubspecContent)) {
          return left(BuildYamlFailure.buildRunnerIsNotExist());
        }

        // Get all dart files in lib and test directories.
        final files = await Future.wait([
          _packageManager.dartFilesCollection(
            dir: Directory('$packagePath/lib'),
          ),
          _packageManager.dartFilesCollection(
            dir: Directory('$packagePath/test'),
          ),
        ]).then((files) => files.expand((list) => list).toSet());

        // Remove generated files to reduce number of files to analyze.
        files.removeWhere((file) {
          final baseName = basename(file.path);
          return baseName.endsWith('.g.dart') ||
              baseName.endsWith('.freezed.dart') ||
              baseName.endsWith('.gr.dart') ||
              baseName.endsWith('.hive.dart');
        });

        // get absolute paths of dart files
        final paths = files.map((file) => absolute(file.path)).toList();

        final sdkPath = await _sdkPath;

        AnalysisContextCollection contextCollection = AnalysisContextCollection(
          includedPaths: paths.sublist(0, 3),
          resourceProvider: PhysicalResourceProvider.INSTANCE,
          sdkPath: sdkPath.fold(
            (_) => exit(1),
            (path) => path,
          ),
        );

        final List<Future<GenerateNamenMapping>> proccess = [];

        for (var absolutePath in paths) {
          final analysisContext = contextCollection.contextFor(absolutePath);
          final session = analysisContext.currentSession;
          proccess.add(_getAnnotationsFromPath(
            packagePath: packagePath,
            absolutePath: absolutePath,
            session: session,
          ));
        }
        final results = await Future.wait<GenerateNamenMapping>(proccess)
            .then((value) => value.where((e) => e.isNotEmpty));

        GenerateNamenMapping combinedMap =
            results.fold<GenerateNamenMapping>({}, (acc, currentMap) {
          currentMap.forEach((key, valueSet) {
            if (acc.containsKey(key)) {
              acc[key]!.addAll(valueSet);
            } else {
              acc[key] = valueSet;
            }
          });

          return acc;
        });

        final builders = _proccessBuilders(combinedMap);

        await _generateBuildYamlFile(builders, packagePath);

        return right(const None());
      },
    );
  }

  Future<Either<None, String>> get _sdkPath async {
    try {
      final command = Platform.isWindows ? 'where' : 'which';
      final processResult = await Process.run(command, ['flutter']);

      final String flutterPath = processResult.stdout.trim();

      final flutterFile = File(flutterPath);

      return right('${flutterFile.parent.path}/cache/dart-sdk');
    } catch (e) {
      return left(const None());
    }
  }

  Either<BuildYamlFailure, File> _findPubspecFile(String packagePath) {
    final pubspecFile = File('$packagePath/pubspec.yaml');
    if (!pubspecFile.existsSync()) {
      return left(BuildYamlFailure.pubspecFileIsNotExist());
    }

    return right(pubspecFile);
  }

  Future<String> _readPubspecContent(File pubspecFile) async {
    return await pubspecFile.readAsString();
  }

  bool _checkBuildRunner(String pubspecContent) {
    return pubspecContent.contains('build_runner');
  }

  Future<GenerateNamenMapping> _getAnnotationsFromPath({
    required AnalysisSession session,
    required String absolutePath,
    required String packagePath,
  }) async {
    final result = await session.getResolvedLibrary(absolutePath);

    final GenerateNamenMapping generateNamenMapping = {};

    if (result is ResolvedLibraryResult) {
      final libraryElement = result.element;
      final units = libraryElement.units;

      for (var unit in units) {
        // ignore 'part of' files
        if (unit.library != libraryElement) continue;

        for (var child in unit.children) {
          for (var meta in child.metadata) {
            final shortName = meta.element?.librarySource?.shortName;
            if (shortName == null || shortName.isEmpty) continue;

            final packageName = shortName.replaceFirst('.dart', '');
            final annotationName = meta.element?.displayName;
            if (annotationName == null || annotationName.isEmpty) continue;

            final generateNameValue = _getGenerateName(
              packageName: packageName,
              annotationName: annotationName,
            );

            final relativePath = relative(packagePath, from: absolutePath);

            generateNameValue.fold(
              () => null,
              (generateName) {
                generateNamenMapping[relativePath] = {
                  ...?generateNamenMapping[relativePath],
                  generateName,
                };
              },
            );
          }
        }
      }
    }

    return generateNamenMapping;
  }

  Option<String> _getGenerateName({
    required String packageName,
    required String annotationName,
  }) {
    if (packageName == 'freezed_annotation') return some('freezed|freezed');
    if (packageName == 'json_serializable') {
      return some('json_serializable|json_serializable');
    }
    if (packageName == 'http') {
      return some('retrofit_generator|retrofit');
    }
    if (packageName == 'hive') {
      return some('hive_generator|hive_generator');
    }
    if (packageName == 'auto_route_annotations') {
      return some('auto_route_generator|autoRouteGenerator');
    }
    if (packageName == 'injectable_annotations') {
      if (annotationName == 'injectableInit') {
        return some('injectable_generator|injectable_config_builder');
      } else {
        return some('injectable_generator|injectable_builder');
      }
    }

    return const None();
  }

  final Set<String> packagesName = {
    'freezed_annotation',
    'json_serializable',
    'http',
    'injectable_annotations',
    'hive',
    'auto_route_annotations',
  };

  final Set<String> generateNames = {
    'freezed|freezed',
    'json_serializable|json_serializable',
    'retrofit_generator|retrofit',
    'hive_generator|hive_generator',
    'auto_route_generator|autoRouteGenerator',
    'injectable_generator|injectable_config_builder',
    'injectable_generator|injectable_builder',
  };

  BuildersMapping _proccessBuilders(GenerateNamenMapping generateNamenMapping) {
    final BuildersMapping builders = {};

    for (String generateName in generateNames) {
      final values = generateNamenMapping.entries.where(
        (element) {
          return element.value.contains(generateName);
        },
      );
      final paths = values.map((e) => e.key);
      builders[generateName] = BuilderInfo(
        enabled: paths.isNotEmpty,
        generateFor: paths.toSet(),
      );
    }

    return builders;
  }

  Future<Either<BuildYamlFailure, None>> _generateBuildYamlFile(
    BuildersMapping builders,
    String packagePath,
  ) async {
    final Map<String, dynamic> buildMap = {
      'targets': {
        "\$default": {
          "builders": builders.map(
            (generateName, info) => MapEntry(
              generateName,
              info.generateFor.isNotEmpty
                  ? {
                      'enabled': true,
                      'generate_for': info.generateFor,
                    }
                  : {
                      'enabled': false,
                    },
            ),
          ),
        }
      }
    };

    String yamlString = json2yaml(buildMap);
    File buildYaml = File('$packagePath/build.yaml');
    await buildYaml.writeAsString(yamlString);

    return right(const None());
  }
}

// Key: Relative path to a Dart file, Value: Set of generate name
typedef GenerateNamenMapping = Map<String, Set<String>>;

// Key: Generator name, Value: BuilderInfo for the generator
typedef BuildersMapping = Map<String, BuilderInfo>;

class BuilderInfo {
  const BuilderInfo({
    required this.enabled,
    required this.generateFor,
  });

  // Indicates whether the builder is enabled
  final bool enabled;

  // Set of files the builder should generate for
  final Set<String> generateFor;
}
