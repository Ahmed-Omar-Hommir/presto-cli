import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:path/path.dart';
import 'package:presto_cli/src/models/models.dart';
import 'package:presto_cli/src/utils/utils.dart';

abstract class IProjectChecker {
  Future<Either<ProjectCheckerFailure, bool>> checkInRootProject();
}

class ProjectChecker implements IProjectChecker {
  const ProjectChecker({
    required IFileManager fileManager,
  }) : _fileManager = fileManager;

  final IFileManager _fileManager;

  @override
  Future<Either<ProjectCheckerFailure, bool>> checkInRootProject() async {
    final pubspecPath = join(Directory.current.path, 'pubspec.yaml');
    final pubspecFile = await _fileManager.readYaml(pubspecPath);

    return pubspecFile.fold(
      (failure) => failure.maybeMap(
        unknown: (value) => left(ProjectCheckerFailure.unknown(value.e)),
        orElse: () => right(false),
      ),
      (contetnt) => right(contetnt['name'] == 'prestoeat'),
    );
  }
}
