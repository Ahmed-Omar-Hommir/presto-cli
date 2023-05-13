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
}

class FlutterCLI implements IFlutterCLI {
  FlutterCLI({
    @visibleForTesting IProcessManager? processManager,
  }) : _processManager = processManager ?? ProcessManager();

  final IProcessManager _processManager;

  bool _checkPubspecFile(String packagePath) {
    final pubspecFile = File(join(packagePath, 'pubspec.yaml'));
    return pubspecFile.existsSync();
  }

  @override
  Future<Either<CliFailure, ProcessResponse>> pubAdd({
    required String packagePath,
    required Set<PackageDependency> dependencies,
  }) async {
    if (dependencies.isEmpty) {
      return const Left(CliFailure.emptyDependencies());
    }
    try {
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
}
