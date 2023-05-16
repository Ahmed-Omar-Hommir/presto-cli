import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart';
import 'package:presto_cli/src/models/file_manager/file_manager_failure.dart';
import 'package:yaml/yaml.dart';

abstract class IFileManager {
  Future<List<String>> findFilesByExtension(
    String extension, {
    String? path,
  });

  Future<Either<FileManagerFailure, Map>> readYaml(String path);
  Future<Either<FileManagerFailure, Set<Directory>>> findPackages(
    Directory dir,
  );
}

class FileManager implements IFileManager {
  FileManager({
    @visibleForTesting IFileFactory? fileFactory,
    @visibleForTesting IYamlWrapper? yamlWrapper,
  })  : _fileFactory = fileFactory ?? FileFactory(),
        _yamlWrapper = yamlWrapper ?? YamlWrapper();

  final IFileFactory _fileFactory;
  final IYamlWrapper _yamlWrapper;

  Future<List<String>> _getFilesMatchingRule({
    required Directory dir,
    required bool Function(String file) rule,
    required bool recursive,
    required bool followLinks,
  }) async {
    final List<String> paths = [];
    await for (var entity in dir.list(
      recursive: recursive,
      followLinks: followLinks,
    )) {
      if (entity is File && rule(entity.path)) {
        paths.add(_fileFactory.create(entity.path).path);
      }
    }

    return paths;
  }

  Future<List<Directory>> _getDirsMatchingRule({
    required Directory dir,
    required bool Function(Directory dir) rule,
    required bool recursive,
    required bool followLinks,
  }) async {
    final List<Directory> directories = [];
    await for (var entity in dir.list(
      recursive: recursive,
      followLinks: followLinks,
    )) {
      if (entity is Directory && rule(entity)) {
        directories.add(entity);
      }
    }

    return directories;
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
  Future<Either<FileManagerFailure, Map>> readYaml(String path) async {
    try {
      final file = _fileFactory.create(path);
      if (!file.existsSync()) {
        return left(FileManagerFailure.fileNotFound());
      }
      final content = await file.readAsString();
      return right(_yamlWrapper.loadYamlFile(content));
    } catch (e) {
      return left(FileManagerFailure.unknown(e));
    }
  }

  @override
  Future<Either<FileManagerFailure, Set<Directory>>> findPackages(
    Directory dir,
  ) async {
    try {
      if (!dir.existsSync()) {
        return left(FileManagerFailure.dirNotFound());
      }

      return _getDirsMatchingRule(
        dir: dir,
        recursive: true,
        followLinks: false,
        rule: (dir) =>
            Directory(dir.path).existsSync() &&
            File(join(dir.path, 'pubspec.yaml')).existsSync(),
      ).then((value) => Right(value.toSet()));
    } catch (e) {
      return left(FileManagerFailure.unknown(e));
    }
  }
}

abstract class IFileFactory {
  File create(String path);
}

class FileFactory implements IFileFactory {
  @override
  File create(String path) => File(path);
}

abstract class IYamlWrapper {
  Map loadYamlFile(String yaml);
}

class YamlWrapper implements IYamlWrapper {
  @override
  Map loadYamlFile(String yaml) => loadYaml(yaml);
}
