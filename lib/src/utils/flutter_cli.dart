import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart';

import '../models/flutter_cli/cli_failure.dart';
import '../models/package_dependency.dart';
import '../models/process/process_response.dart';
import 'process_manager.dart';

abstract class IFlutterCLI {
  Future<Either<CliFailure, ProcessResponse>> pubAdd({
    required String packagePath,
    required Set<PackageDependency> dependencies,
  });

  Future<Either<CliFailure, ProcessResponse>> createNewPackage({
    required String packageName,
    String? packagePath,
  });

  Future<Either<CliFailure, ProcessResponse>> genL10N({String? packagePath});
  Future<Either<CliFailure, ProcessResponse>> buildRunner(
    Directory workingDirectory, {
    bool deleteConflictingOutputs = false,
  });
}

class FlutterCLI implements IFlutterCLI {
  FlutterCLI({
    @visibleForTesting IProcessManager? processManager,
  }) : _processManager = processManager ?? ProcessManager();

  final IProcessManager _processManager;

  bool _checkPubspecFile(String? packagePath) {
    final path = packagePath ?? Directory.current.path;
    final pubspecFile = File(join(path, 'pubspec.yaml'));
    return pubspecFile.existsSync();
  }

  bool _checkPathExist(String? packagePath) {
    final path = packagePath ?? Directory.current.path;
    final packageDir = Directory(path);
    return packageDir.existsSync();
  }

  @override
  Future<Either<CliFailure, ProcessResponse>> pubAdd({
    required String packagePath,
    required Set<PackageDependency> dependencies,
  }) async {
    try {
      if (dependencies.isEmpty) {
        return const Left(CliFailure.emptyDependencies());
      }
      if (!_checkPathExist(packagePath)) {
        return const Left(CliFailure.invalidPackagePath());
      }
      if (!_checkPubspecFile(packagePath)) {
        return const Left(CliFailure.pubspecFileNotFound());
      }

      final result = await _processManager.run(
        'flutter',
        [
          'pub',
          'add',
          ...dependencies.map((e) => '${e.name}:${e.version}'),
        ],
        workingDirectory: packagePath,
      );

      return right(ProcessResponse.fromProcessResult(result));
    } catch (e) {
      return left(CliFailure.unknown(e));
    }
  }

  bool _isValidPackageName(String packageName) {
    final RegExp pattern = RegExp(r'^[a-z0-9]+(_[a-z0-9]+)*$');
    return pattern.hasMatch(packageName);
  }

  bool _packageIsExist({
    required String packageName,
    required String packagePath,
  }) {
    final packageDir = Directory(join(packagePath, packageName));
    return packageDir.existsSync();
  }

  @override
  Future<Either<CliFailure, ProcessResponse>> createNewPackage({
    required String packageName,
    @visibleForTesting String? packagePath,
  }) async {
    try {
      if (!_isValidPackageName(packageName)) {
        return const Left(CliFailure.invalidPackageName());
      }

      if (!_checkPathExist(packagePath)) {
        return const Left(CliFailure.invalidPackagePath());
      }

      if (_packageIsExist(
        packageName: packageName,
        packagePath: packagePath ?? Directory.current.path,
      )) {
        return const Left(CliFailure.packageAlreadyExists());
      }

      final result = await _processManager.run(
        'flutter',
        [
          'create',
          '--template=package',
          packageName,
        ],
        workingDirectory: packagePath,
      );

      return right(ProcessResponse.fromProcessResult(result));
    } catch (e) {
      return left(CliFailure.unknown(e));
    }
  }

  @override
  Future<Either<CliFailure, ProcessResponse>> genL10N({
    String? packagePath,
  }) async {
    try {
      if (!_checkPathExist(packagePath)) {
        return const Left(CliFailure.invalidPackagePath());
      }
      if (!_checkPubspecFile(packagePath)) {
        return const Left(CliFailure.pubspecFileNotFound());
      }
      final result = await _processManager.run(
        'flutter',
        ['gen-l10n'],
        workingDirectory: packagePath,
      );

      return right(ProcessResponse.fromProcessResult(result));
    } catch (e) {
      return left(CliFailure.unknown(e));
    }
  }

  @override
  Future<Either<CliFailure, ProcessResponse>> buildRunner(
    Directory workingDirectory, {
    bool deleteConflictingOutputs = false,
  }) async {
    try {
      if (!workingDirectory.existsSync()) {
        return const Left(CliFailure.directoryNotFound());
      }
      final args = ['pub', 'run', 'build_runner', 'build'];

      if (deleteConflictingOutputs) {
        args.add('--delete-conflicting-outputs');
      }

      final result = await _processManager.run(
        'flutter',
        args,
        workingDirectory: workingDirectory.path,
      );

      return Right(ProcessResponse.fromProcessResult(result));
    } catch (e) {
      return left(CliFailure.unknown(e));
    }
  }
}
