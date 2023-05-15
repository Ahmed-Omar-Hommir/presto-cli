import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:path/path.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:presto_cli/src/models/file_manager/file_manager_failure.dart';
import 'package:test/test.dart';

import 'helper.dart';

void main() {
  late IFileManager sut;

  setUp(() {
    sut = FileManager();
  });

  group(
    'Find Files By Extension',
    () {
      // Todo: implement test cases.
      test(
        'should return a list of paths to files with the given extension.',
        () async {
          // Arrange
          final tempDir = Directory.systemTemp.createTempSync();
          makeDartFiles(tempDir);

          // Act
          final result = await sut.findFilesByExtension(
            'dart',
            path: tempDir.path,
          );

          // Assert
          expect(result..sort(), dartFiles(tempDir));
        },
      );
    },
  );

  group(
    'Read Pubspec Yaml',
    () {
      group(
        'Success cases',
        () {
          test(
            'should return a Right with a map containing the yaml content.',
            () async {
              // Arrange
              final tempDir = Directory.systemTemp.createTempSync();
              createPubspecFile(tempDir);

              final pubspecFile = File(join(tempDir.path, 'pubspec.yaml'));

              // Act
              final result = await sut.readYaml(pubspecFile);

              // Assert
              expect(result, isA<Right>());
              expect(
                result.fold(
                  (failure) => fail('Result returned a Left.'),
                  (response) => response,
                ),
                isA<Map>(),
              );
            },
          );
        },
      );
      group(
        'Failure cases',
        () {
          test(
            'should return a Left with a $FileManagerFailureFileNotFound when the file does not exist.',
            () async {
              // Arrange
              final tempDir = Directory.systemTemp.createTempSync();
              final pubspecFile = File(join(tempDir.path, 'pubspec.yaml'));

              // Act
              final result = await sut.readYaml(pubspecFile);

              // Assert
              expect(result, isA<Left>());
              expect(
                result.fold(
                  (failure) => failure,
                  (response) => fail('Result returned a Right.'),
                ),
                isA<FileManagerFailureFileNotFound>(),
              );
            },
          );

          test(
            'should return a Left with a $FileManagerFailureUnknown when throw exception.',
            () async {
              // Todo: implement test case (Mock File and LoadYaml).
            },
          );
        },
      );
    },
  );
}
