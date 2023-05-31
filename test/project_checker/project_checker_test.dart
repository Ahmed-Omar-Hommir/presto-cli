import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:presto_cli/src/models/file_manager/file_manager_failure.dart';
import 'package:presto_cli/src/models/models.dart';
import 'package:presto_cli/src/utils/utils.dart';
import 'package:test/test.dart';

import '../mocks.mocks.dart';

void main() {
  late IProjectChecker sut;
  late MockIFileManager mockFileManager;

  setUp(() {
    mockFileManager = MockIFileManager();
    sut = ProjectChecker(fileManager: mockFileManager);
  });

  group('Check in root project', () {
    group('Success cases', () {
      test(
        'should retrun false when call readYaml and return orElse failure.',
        () async {
          // Arrange
          when(mockFileManager.readYaml(any)).thenAnswer(
            (_) async => left(FileManagerFailure.dirNotFound()),
          );

          // Act
          final result = await sut.checkInRootProject();

          // Assert
          expect(result, isA<Right>());
          expect(
            result.fold(
              (_) => fail('Result returned a failure'),
              (response) => response,
            ),
            false,
          );

          verify(mockFileManager.readYaml(any)).called(1);
          verifyNoMoreInteractions(mockFileManager);
        },
      );

      test(
        'should retrun false when call readYaml and return content with incorrect package name.',
        () async {
          // Arrange
          when(mockFileManager.readYaml(any)).thenAnswer(
            (_) async => right({'name': 'wrong_package_name'}),
          );

          // Act
          final result = await sut.checkInRootProject();

          // Assert
          expect(result, isA<Right>());
          expect(
            result.fold(
              (_) => fail('Result returned a failure'),
              (response) => response,
            ),
            false,
          );

          verify(mockFileManager.readYaml(any)).called(1);
          verifyNoMoreInteractions(mockFileManager);
        },
      );
      test(
        'should retrun true when call readYaml and return content with correct package name.',
        () async {
          // Arrange
          when(mockFileManager.readYaml(any)).thenAnswer(
            (_) async => right({'name': 'prestoeat'}),
          );

          // Act
          final result = await sut.checkInRootProject();

          // Assert
          expect(result, isA<Right>());
          expect(
            result.fold(
              (_) => fail('Result returned a failure'),
              (response) => response,
            ),
            true,
          );

          verify(mockFileManager.readYaml(any)).called(1);
          verifyNoMoreInteractions(mockFileManager);
        },
      );
    });
    group('Failure cases', () {
      test(
        'should return Left<$ProjectCheckerFailureUnknown> when call readYaml and return unknown error.',
        () async {
          // Arrange
          when(mockFileManager.readYaml(any)).thenAnswer(
            (_) async => left(FileManagerFailure.unknown(Exception(''))),
          );

          // Act
          final result = await sut.checkInRootProject();

          // Assert
          expect(result, isA<Left>());
          expect(
            result.fold(
              (failure) => failure,
              (_) => fail('Result returned a Right'),
            ),
            isA<ProjectCheckerFailureUnknown>(),
          );

          verify(mockFileManager.readYaml(any)).called(1);
          verifyNoMoreInteractions(mockFileManager);
        },
      );
    });
  });
}
