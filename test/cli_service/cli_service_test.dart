import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:test/test.dart';

import '../mocks.mocks.dart';
import 'helper.dart';

void main() {
  late ICliService sut;
  late MockCliRemoteServiceApi mockApi;

  setUp(() {
    mockApi = MockCliRemoteServiceApi();
    sut = CliService(api: mockApi);
  });

  group('Success case', () {
    test(
      'should return a Right when the request is successful',
      () async {
        // Arrange
        when(mockApi.getVersionDartFileFromRepo()).thenAnswer(
          (_) async => versionFileContent,
        );

        // Act
        final result = await sut.getLastVersion();

        // Assert
        expect(
          version,
          result.fold(
            (_) => fail('Should not be a Left'),
            (version) => version,
          ),
        );

        verify(mockApi.getVersionDartFileFromRepo()).called(1);
        verifyNoMoreInteractions(mockApi);
      },
    );
  });
  group('Failure cases', () {
    test(
      'should return a Left when the request fails',
      () async {
        // Arrange

        when(mockApi.getVersionDartFileFromRepo()).thenThrow(Exception());

        // Act
        final result = await sut.getLastVersion();

        // Assert
        expect(result, isA<Left>());

        verify(mockApi.getVersionDartFileFromRepo()).called(1);
        verifyNoMoreInteractions(mockApi);
      },
    );
    test(
      'should return a Left when the version return null',
      () async {
        // Arrange

        when(mockApi.getVersionDartFileFromRepo()).thenAnswer(
          (_) async => invalidVersionFileContent,
        );

        // Act
        final result = await sut.getLastVersion();

        // Assert
        expect(
          CliServiceMessage.versionFileNotFound,
          result.fold(
            (message) => message,
            (_) => fail('Should not be a Right'),
          ),
        );

        verify(mockApi.getVersionDartFileFromRepo()).called(1);
        verifyNoMoreInteractions(mockApi);
      },
    );
  });
}
