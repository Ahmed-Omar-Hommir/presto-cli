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
    Directory dir, {
    Future<bool> Function(Directory dir)? where,
  });
}

class FileManager implements IFileManager {
  const FileManager({
    @visibleForTesting IFileFactory? fileFactory,
    @visibleForTesting IYamlWrapper? yamlWrapper,
  })  : _fileFactory = fileFactory ?? const FileFactory(),
        _yamlWrapper = yamlWrapper ?? const YamlWrapper();

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
    required Future<bool> Function(Directory dir) where,
    required bool recursive,
    required bool followLinks,
  }) async {
    final List<Directory> directories = [];
    await for (var entity in dir.list(
      recursive: recursive,
      followLinks: followLinks,
    )) {
      if (entity is Directory && await where(entity)) {
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
    Directory directory, {
    Future<bool> Function(Directory dir)? where,
  }) async {
    try {
      if (!directory.existsSync()) {
        return left(FileManagerFailure.dirNotFound());
      }

      return _getDirsMatchingRule(
        dir: directory,
        recursive: true,
        followLinks: false,
        where: (dir) async =>
            Directory(dir.path).existsSync() &&
            File(join(dir.path, 'pubspec.yaml')).existsSync() &&
            (where != null ? await where(dir) : true),
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
  const FileFactory();
  @override
  File create(String path) => File(path);
}

abstract class IYamlWrapper {
  Map loadYamlFile(String yaml);
}

class YamlWrapper implements IYamlWrapper {
  const YamlWrapper();
  @override
  Map loadYamlFile(String yaml) => loadYaml(yaml);
}
