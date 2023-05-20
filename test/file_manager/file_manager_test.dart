import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:presto_cli/src/models/file_manager/file_manager_failure.dart';
import 'package:test/test.dart';

import 'file_manager_test.mocks.dart';
import 'helper.dart';

@GenerateMocks([
  IFileFactory,
  IYamlWrapper,
  File,
  Directory,
])
void main() {
  late IFileManager sut;
  late IFileManager sutWithMock;
  late MockIFileFactory mockIFileFactory;
  late MockIYamlWrapper mockIYamlWrapper;
  late MockFile mockFile;
  late MockDirectory mockDirectory;
  late Directory tempDir;

  setUp(() {
    mockFile = MockFile();

    mockDirectory = MockDirectory();
    tempDir = Directory.systemTemp.createTempSync();

    mockIFileFactory = MockIFileFactory();
    mockIYamlWrapper = MockIYamlWrapper();

    sut = FileManager();
    sutWithMock = FileManager(
      fileFactory: mockIFileFactory,
      yamlWrapper: mockIYamlWrapper,
    );
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  group(
    'Find Files By Extension',
    () {
      // Todo: implement test cases.
      test(
        'should return a list of paths to files with the given extension.',
        () async {
          // Arrange
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
    'Read Yaml',
    () {
      group(
        'Success cases',
        () {
          test(
            'should return a Right with a map containing the yaml content.',
            () async {
              // Arrange
              createPubspecFile(tempDir);

              final pubspecFile = File(join(tempDir.path, 'pubspec.yaml'));

              // Act
              final result = await sut.readYaml(pubspecFile.path);

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
              final pubspecFile = File(join(tempDir.path, 'pubspec.yaml'));

              // Act
              final result = await sut.readYaml(pubspecFile.path);

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
            'should return a Left with a $FileManagerFailureUnknown when loadYamlFile throw exception.',
            () async {
              // Arrange
              when(mockIFileFactory.create(any)).thenReturn(mockFile);
              when(mockFile.existsSync()).thenReturn(true);
              when(mockFile.readAsString()).thenAnswer((_) async => '');
              when(mockIYamlWrapper.loadYamlFile(any)).thenThrow(Exception());

              // Act
              final result = await sutWithMock.readYaml(Directory.current.path);

              // Assert
              expect(result, isA<Left>());
              expect(
                result.fold(
                  (failure) => failure,
                  (response) => fail('Result returned a Right.'),
                ),
                isA<FileManagerFailureUnknown>(),
              );

              verify(mockIYamlWrapper.loadYamlFile(any)).called(1);
              verify(mockIFileFactory.create(any)).called(1);
              verify(mockFile.existsSync()).called(1);
              verify(mockFile.readAsString()).called(1);

              verifyNoMoreInteractions(mockFile);
              verifyNoMoreInteractions(mockIFileFactory);
              verifyNoMoreInteractions(mockIYamlWrapper);
            },
          );
          test(
            'should return a Left with a $FileManagerFailureUnknown when File throw exception.',
            () async {
              // Arrange
              when(mockIFileFactory.create(any)).thenThrow(Exception());

              // Act
              final result = await sutWithMock.readYaml(Directory.current.path);

              // Assert
              expect(result, isA<Left>());
              expect(
                result.fold(
                  (failure) => failure,
                  (response) => fail('Result returned a Right.'),
                ),
                isA<FileManagerFailureUnknown>(),
              );

              verify(mockIFileFactory.create(any)).called(1);
              verifyNoMoreInteractions(mockIFileFactory);

              verifyZeroInteractions(mockFile);
              verifyZeroInteractions(mockIYamlWrapper);
            },
          );
          test(
            'should return a Left with a $FileManagerFailureUnknown when File.existsSync throw exception.',
            () async {
              // Arrange
              when(mockIFileFactory.create(any)).thenReturn(mockFile);
              when(mockFile.existsSync()).thenThrow(Exception());

              // Act
              final result = await sutWithMock.readYaml(Directory.current.path);

              // Assert
              expect(result, isA<Left>());
              expect(
                result.fold(
                  (failure) => failure,
                  (response) => fail('Result returned a Right.'),
                ),
                isA<FileManagerFailureUnknown>(),
              );

              verify(mockIFileFactory.create(any)).called(1);
              verify(mockFile.existsSync()).called(1);

              verifyNoMoreInteractions(mockIFileFactory);
              verifyNoMoreInteractions(mockFile);
              verifyZeroInteractions(mockIYamlWrapper);
            },
          );
          test(
            'should return a Left with a $FileManagerFailureUnknown when File.readAsString throw exception.',
            () async {
              // Arrange
              when(mockIFileFactory.create(any)).thenReturn(mockFile);
              when(mockFile.existsSync()).thenReturn(true);
              when(mockFile.readAsString()).thenThrow(Exception());

              // Act
              final result = await sutWithMock.readYaml(Directory.current.path);

              // Assert
              expect(result, isA<Left>());
              expect(
                result.fold(
                  (failure) => failure,
                  (response) => fail('Result returned a Right.'),
                ),
                isA<FileManagerFailureUnknown>(),
              );

              verify(mockIFileFactory.create(any)).called(1);
              verify(mockFile.existsSync()).called(1);
              verify(mockFile.readAsString()).called(1);

              verifyNoMoreInteractions(mockIFileFactory);
              verifyNoMoreInteractions(mockFile);
              verifyZeroInteractions(mockIYamlWrapper);
            },
          );
        },
      );
    },
  );

  group(
    'Find Packages',
    () {
      group(
        'Success cases',
        () {
          test('should return Right with package paths.', () async {
            // Arrange
            final subDir = Directory(join(tempDir.path, 'sub_dir'))
              ..createSync();
            createTempPackage(tempDir, packageName: 'package_1');
            createTempPackage(tempDir, packageName: 'package_2');
            createTempPackage(subDir, packageName: 'package_3');
            createTempPackage(tempDir, packageName: 'package_4');

            // Act
            final result = await sut.findPackages(tempDir);

            // Assert
            expect(result, isA<Right>());
            expect(
                result.fold(
                  (failure) => fail('Result returned a Left.'),
                  (response) =>
                      response.map((res) => res.path).toList()..sort(),
                ),
                {
                  join(tempDir.path, 'package_1'),
                  join(tempDir.path, 'package_2'),
                  join(subDir.path, 'package_3'),
                  join(tempDir.path, 'package_4'),
                }.toList()
                  ..sort());
          });
          test(
            'should return Right with package paths containing a ahmed_package.',
            () async {
              // Arrange
              final subDir = Directory(join(tempDir.path, 'sub_dir'))
                ..createSync();
              createTempPackage(tempDir, packageName: 'ahmed_package_1');
              createTempPackage(tempDir, packageName: 'package_2');
              createTempPackage(subDir, packageName: 'ahmed_package_3');
              createTempPackage(tempDir, packageName: 'ahmed_package_4');
              createTempPackage(tempDir, packageName: 'package_5');

              // Act
              final result = await sut.findPackages(
                tempDir,
                where: (dir) async => dir.path.contains('ahmed_package'),
              );

              // Assert
              expect(result, isA<Right>());
              expect(
                  result.fold(
                    (failure) => fail('Result returned a Left.'),
                    (response) =>
                        response.map((res) => res.path).toList()..sort(),
                  ),
                  {
                    join(tempDir.path, 'ahmed_package_1'),
                    join(tempDir.path, 'ahmed_package_4'),
                    join(subDir.path, 'ahmed_package_3'),
                  }.toList()
                    ..sort());
            },
          );
          test(
            'should return Right with empty package paths where condition always false.',
            () async {
              // Arrange
              final subDir = Directory(join(tempDir.path, 'sub_dir'))
                ..createSync();
              createTempPackage(tempDir, packageName: 'package_1');
              createTempPackage(tempDir, packageName: 'package_2');
              createTempPackage(subDir, packageName: 'package_3');
              createTempPackage(tempDir, packageName: 'package_4');

              // Act
              final result = await sut.findPackages(
                tempDir,
                where: (dir) async => false,
              );

              // Assert
              expect(result, isA<Right>());
              expect(
                result.fold(
                  (failure) => fail('Result returned a Left.'),
                  (response) =>
                      response.map((res) => res.path).toList()..sort(),
                ),
                [],
              );
            },
          );
        },
      );
      group(
        'Failure cases',
        () {
          test(
            'should return Left $FileManagerFailureDirNotFound when dir does not exist.',
            () async {
              // Arrange
              final tempDir = Directory(join(
                Directory.systemTemp.createTempSync().path,
                'not_exist',
              ));

              // Act
              final result = await sut.findPackages(tempDir);

              // Assert
              expect(result, isA<Left>());
              expect(
                result.fold(
                  (failure) => failure,
                  (response) => fail('Result returned a Right.'),
                ),
                isA<FileManagerFailureDirNotFound>(),
              );
            },
          );
          test(
            'should return Left $FileManagerFailureUnknown when directory.existsSync throw exception.',
            () async {
              // Arrange
              when(mockDirectory.existsSync()).thenThrow(Exception());

              // Act
              final result = await sut.findPackages(mockDirectory);

              // Assert
              expect(result, isA<Left>());
              expect(
                result.fold(
                  (failure) => failure,
                  (response) => fail('Result returned a Right.'),
                ),
                isA<FileManagerFailureUnknown>(),
              );
            },
          );
        },
      );
    },
  );
}
