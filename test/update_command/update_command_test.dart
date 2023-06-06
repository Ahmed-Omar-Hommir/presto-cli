import 'package:args/command_runner.dart';
import 'package:dartz/dartz.dart';
import 'package:mason/mason.dart';
import 'package:mockito/mockito.dart';
import 'package:presto_cli/src/commands/update_command.dart';
import 'package:test/test.dart';

import '../mocks.mocks.dart';
import 'helper.dart';

void main() {
  late CommandRunner<int> sut;

  late MockCliService mockCliService;
  late MockILogger mockLogger;
  late MockProgress mockProgress;

  setUp(() {
    mockProgress = MockProgress();
    mockCliService = MockCliService();
    mockLogger = MockILogger();

    sut = CommandRunner<int>('test', 'test')
      ..addCommand(
        UpdateCommand(
          cliService: mockCliService,
          logger: mockLogger,
        ),
      );
  });

  group('Sucess cases', () {
    test(
      'shoule update cli when has new version and return ${ExitCode.success.code}',
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

        // Act
        final result = await sut.run(['update']);

        // Assert
        expect(result, ExitCode.success.code);

        verify(mockLogger.progress(UpdateCommandMessage.checkingForUpdates))
            .called(1);
        verifyNoMoreInteractions(mockLogger);

        verify(mockCliService.getLastVersion()).called(1);
        verifyNoMoreInteractions(mockCliService);

        verify(mockProgress.update(UpdateCommandMessage.updating)).called(1);
        verify(mockProgress.complete(UpdateCommandMessage.updated)).called(1);
        verifyNoMoreInteractions(mockProgress);
      },
    );

    test(
      'shoule return ${ExitCode.success.code} when cli is up to date',
      () async {
        // Arrange

        // Act
        final result = await sut.run(['update']);

        // Assert
        expect(result, ExitCode.success.code);
      },
    );
  });
  group(
    'Failure cases',
    () {
      test(
        'description',
        () {},
      );
    },
  );
}
