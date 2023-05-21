import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:path/path.dart';
import 'package:presto_cli/src/models/models.dart';
import 'package:test/test.dart';

void directoryDoesNotExistTest({
  required Future<Either<CliFailure, Process>> Function(Directory tempDir) act,
  required void Function() assertions,
}) {
  test(
    'should return Left CliFailureDirectoryNotFound when directory does not exist.',
    () async {
      // Arrange
      final tempDir = Directory(join(
        Directory.systemTemp.createTempSync().path,
        'directory',
        'does',
        'not',
        'exist',
      ));

      // Act
      final result = await act(tempDir);

      // Assert
      expect(result, isA<Left>());
      expect(
        result.fold(
          (failure) => failure,
          (_) => fail('Result returned a Right'),
        ),
        isA<CliFailureDirectoryNotFound>(),
      );

      assertions();
    },
  );
}
