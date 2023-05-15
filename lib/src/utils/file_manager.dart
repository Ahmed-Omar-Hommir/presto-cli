import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:presto_cli/src/models/file_manager/file_manager_failure.dart';
import 'package:yaml/yaml.dart';

abstract class IFileManager {
  Future<List<String>> findFilesByExtension(
    String extension, {
    String? path,
  });

  Future<Either<FileManagerFailure, Map>> readYaml(File file);
}

class FileManager implements IFileManager {
  Future<List<String>> _getFilesMatchingRule({
    required Directory dir,
    required bool Function(String path) rule,
    required bool recursive,
    required bool followLinks,
  }) async {
    final List<String> paths = [];
    await for (var entity in dir.list(
      recursive: recursive,
      followLinks: followLinks,
    )) {
      if (entity is File && rule(entity.path)) {
        paths.add(File(entity.path).path);
      }
    }

    return paths;
  }

  @override
  Future<List<String>> findFilesByExtension(
    String extension, {
    String? path,
    bool recursive = true,
    followLinks = false,
  }) async {
    final dir = path == null ? Directory.current : Directory(path);
    return await _getFilesMatchingRule(
      dir: dir,
      rule: (path) => path.endsWith('.$extension'),
      recursive: recursive,
      followLinks: followLinks,
    );
  }

  @override
  Future<Either<FileManagerFailure, Map>> readYaml(File file) async {
    try {
      if (!file.existsSync()) {
        return left(FileManagerFailure.fileNotFound());
      }
      final content = await file.readAsString();
      return right(loadYaml(content));
    } catch (e) {
      return left(FileManagerFailure.unknown(e));
    }
  }
}
