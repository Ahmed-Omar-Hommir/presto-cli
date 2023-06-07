import 'package:args/command_runner.dart';
import 'package:dartz/dartz.dart';
import 'package:mason/mason.dart' as mason;
import 'package:mockito/mockito.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:presto_cli/src/commands/update_command.dart';
import 'package:presto_cli/src/version.dart';
import 'package:test/test.dart';

import '../mocks.mocks.dart';
import 'helper.dart';

void main() {
  late CommandRunner<int> sut;

  late MockCliService mockCliService;
  late MockILogger mockLogger;
  late MockProgress mockProgress;
  late MockIDartCLI mockDartCLI;
  late MockProcess mockProcess;

  setUp(() {
    mockProcess = MockProcess();
    mockProgress = MockProgress();
    mockCliService = MockCliService();
    mockLogger = MockILogger();
    mockDartCLI = MockIDartCLI();

    sut = CommandRunner<int>('test', 'test')
      ..addCommand(
        UpdateCommand(
          cliService: mockCliService,
          logger: mockLogger,
          dartCLI: mockDartCLI,
        ),
      );
  });

  group('Sucess cases', () {
    test(
      'shoule update cli when has new version and return ${mason.ExitCode.success.code}',
      () async {
        // Arrange

        when(mockLogger.progress(UpdateCommandMessage.checkingForUpdates))
            .thenReturn(mockProgress);

        when(mockCliService.getLastVersion()).thenAnswer(
          (_) async => Right(oldVersion),
        );

        when(mockProgress.update(UpdateCommandMessage.updating))
            .thenReturn(null);

        when(mockProgress.complete(UpdateCommandMessage.updated))
            .thenReturn(null);

        when(mockDartCLI.installCliFromRepository(
                url: RemoteRepositoryInfo.url))
            .thenAnswer((_) async => Right(mockProcess));

        when(mockProcess.exitCode).thenAnswer((_) async => 0);

        // Act
        final result = await sut.run(['update']);

        // Assert
        expect(result, mason.ExitCode.success.code);

        verify(mockLogger.progress(UpdateCommandMessage.checkingForUpdates))
            .called(1);
        verifyNoMoreInteractions(mockLogger);

        verify(mockCliService.getLastVersion()).called(1);
        verifyNoMoreInteractions(mockCliService);

        verify(mockProgress.update(UpdateCommandMessage.updating)).called(1);
        verify(mockProgress.complete(UpdateCommandMessage.updated)).called(1);
        verifyNoMoreInteractions(mockProgress);

        verify(mockDartCLI.installCliFromRepository(
                url: RemoteRepositoryInfo.url))
            .called(1);
        verifyNoMoreInteractions(mockDartCLI);

        verify(mockProcess.exitCode).called(1);
        verifyNoMoreInteractions(mockProcess);
      },
    );
    test(
      'shoule return ${mason.ExitCode.success.code} when cli is up to date',
      () async {
        // Arrange

        when(mockLogger.progress(UpdateCommandMessage.checkingForUpdates))
            .thenReturn(mockProgress);

        when(mockCliService.getLastVersion()).thenAnswer(
          (_) async => Right(packageVersion),
        );

        when(mockProgress.complete(UpdateCommandMessage.alreadyLatestVersion))
            .thenReturn(null);

        // Act
        final result = await sut.run(['update']);

        // Assert
        expect(result, mason.ExitCode.success.code);

        verify(mockLogger.progress(UpdateCommandMessage.checkingForUpdates))
            .called(1);
        verifyNoMoreInteractions(mockLogger);

        verify(mockCliService.getLastVersion()).called(1);
        verifyNoMoreInteractions(mockCliService);

        verify(mockProgress.complete(UpdateCommandMessage.alreadyLatestVersion))
            .called(1);
        verifyNoMoreInteractions(mockProgress);

        verifyZeroInteractions(mockDartCLI);
        verifyZeroInteractions(mockProcess);
      },
    );
  });
  group(
    'Failure cases',
    () {
      test(
        'should return ${mason.ExitCode.unavailable.code} print error when getLastVersion return Left',
        () async {
          // Arrange
          when(mockLogger.progress(UpdateCommandMessage.checkingForUpdates))
              .thenReturn(mockProgress);

          when(mockLogger.error(any)).thenReturn(null);

          when(mockCliService.getLastVersion()).thenAnswer(
            (_) async => Left('error'),
          );

          when(mockProgress.cancel()).thenReturn(null);

          // Act
          final result = await sut.run(['update']);

          // Assert
          expect(result, mason.ExitCode.unavailable.code);

          verify(mockLogger.progress(UpdateCommandMessage.checkingForUpdates))
              .called(1);
          verify(mockLogger.error(any)).called(1);
          verifyNoMoreInteractions(mockLogger);

          verify(mockCliService.getLastVersion()).called(1);
          verifyNoMoreInteractions(mockCliService);

          verify(mockProgress.cancel()).called(1);
          verifyNoMoreInteractions(mockProgress);

          verifyZeroInteractions(mockDartCLI);
          verifyZeroInteractions(mockProcess);
        },
      );
      test(
        'should return ${mason.ExitCode.unavailable.code} print error when installCliFromRepository return Left',
        () async {
          // Arrange
          when(mockLogger.progress(UpdateCommandMessage.checkingForUpdates))
              .thenReturn(mockProgress);

          when(mockCliService.getLastVersion()).thenAnswer(
            (_) async => Right(oldVersion),
          );

          when(mockProgress.update(UpdateCommandMessage.updating))
              .thenReturn(null);

          when(mockDartCLI.installCliFromRepository(
            url: RemoteRepositoryInfo.url,
          )).thenAnswer(
            (_) async => Left(CliFailure.unknown('error')),
          );

          when(mockLogger.error(any)).thenReturn(null);

          when(mockProgress.cancel()).thenReturn(null);

          // Act
          final result = await sut.run(['update']);

          // Assert
          expect(result, mason.ExitCode.unavailable.code);

          verify(mockLogger.progress(UpdateCommandMessage.checkingForUpdates))
              .called(1);
          verify(mockLogger.error(any)).called(1);
          verifyNoMoreInteractions(mockLogger);

          verify(mockCliService.getLastVersion()).called(1);
          verifyNoMoreInteractions(mockCliService);

          verify(mockProgress.update(UpdateCommandMessage.updating)).called(1);
          verify(mockProgress.cancel()).called(1);
          verifyNoMoreInteractions(mockProgress);

          verify(mockDartCLI.installCliFromRepository(
                  url: RemoteRepositoryInfo.url))
              .called(1);
          verifyNoMoreInteractions(mockDartCLI);

          verifyZeroInteractions(mockProcess);
        },
      );
      test(
        'should return ${mason.ExitCode.unavailable.code} print error when throw exception',
        () async {
          // Arrange
          when(mockLogger.progress(UpdateCommandMessage.checkingForUpdates))
              .thenThrow(Exception());
          when(mockLogger.error(any)).thenReturn(null);

          // Act
          final result = await sut.run(['update']);

          // Assert
          expect(result, mason.ExitCode.unavailable.code);

          verify(mockLogger.progress(UpdateCommandMessage.checkingForUpdates))
              .called(1);
          verify(mockLogger.error(any)).called(1);
          verifyNoMoreInteractions(mockLogger);

          verifyZeroInteractions(mockCliService);
          verifyZeroInteractions(mockProgress);
          verifyZeroInteractions(mockDartCLI);
          verifyZeroInteractions(mockProcess);
        },
      );
    },
  );
}
