import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:presto_cli/src/utils/magic_lancher_strategies.dart';
import 'package:test/test.dart';

import '../mocks.mocks.dart';

void main() {
  late IMagicCommandStrategy sut;
  late MockIFlutterCLI mockFlutterCLI;

  setUp(() {
    mockFlutterCLI = MockIFlutterCLI();
    sut = MagicBuildRunnerStrategy(
      flutterCLI: mockFlutterCLI,
      deleteConflictingOutputs: false,
    );
    when(mockFlutterCLI.buildRunner(any)).thenAnswer((_) async {
      return left(CliFailure.directoryNotFound());
    });
    when(mockFlutterCLI.clean(any)).thenAnswer((_) async {
      return left(CliFailure.directoryNotFound());
    });
  });

  group('Build Runner Strategy', () {
    test('should call buildRuner when run commane', () async {
      // arrange
      sut = MagicBuildRunnerStrategy(
        flutterCLI: mockFlutterCLI,
        deleteConflictingOutputs: false,
      );
      // act
      final result = await sut.runCommand(Directory.current);
      // assert
      expect(result, isA<Either<CliFailure, Process>>());
      verify(mockFlutterCLI.buildRunner(any)).called(1);
      verifyNoMoreInteractions(mockFlutterCLI);
    });
  });
  group('Clean Strategy', () {
    test('should call clean when run commane', () async {
      // arrange
      sut = MagicCleanStrategy(flutterCLI: mockFlutterCLI);
      // act
      final result = await sut.runCommand(Directory.current);
      // assert
      expect(result, isA<Either<CliFailure, Process>>());
      verify(mockFlutterCLI.clean(any)).called(1);
      verifyNoMoreInteractions(mockFlutterCLI);
    });
  });
}
