import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:dartz/dartz.dart';
import 'package:mason/mason.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart';
import 'package:presto_cli/src/commands/fcm_test_command.dart';
import 'package:presto_cli/src/models/file_manager/file_manager_failure.dart';
import 'package:test/test.dart';

import '../mocks.mocks.dart';
import 'helper.dart';

void main() {
  late CommandRunner<int> sut;
  late Directory tempDir;
  late MockIDirectoryFactory mockIDirectoryFactory;
  late MockILogger mockILogger;
  late MockIFileManager mockIFileManager;
  late MockDirectory mockDirectory;
  late MockIFcmService mockIFcmService;

  String jsonFilePath() {
    return join(tempDir.path, fileName);
  }

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync();

    mockIDirectoryFactory = MockIDirectoryFactory();
    mockILogger = MockILogger();
    mockIFileManager = MockIFileManager();
    mockDirectory = MockDirectory();
    mockIFcmService = MockIFcmService();

    when(mockDirectory.path).thenReturn(tempDir.path);
    when(mockIDirectoryFactory.current).thenReturn(mockDirectory);

    sut = CommandRunner<int>('test', 'test')
      ..addCommand(FCMTestCommand(
        directoryFactory: mockIDirectoryFactory,
        logger: mockILogger,
        fileManager: mockIFileManager,
        fcmService: mockIFcmService,
      ));
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  group(
    'Success case',
    () {
      test(
        'should return 0 when run command successfully',
        () async {
          // Arrange
          when(mockIFileManager.readJson(jsonFilePath())).thenAnswer(
            (_) async => right(jsonReuest),
          );

          when(mockILogger.info(
            FCMTesterMessage.sendNotificationSuccess,
          )).thenReturn(null);

          whenSendNotification(
            mockIFcmService: mockIFcmService,
          ).thenAnswer(
            (_) async => right(None()),
          );

          // Act
          final result = await sut.run([command]);

          // Assert
          expect(result, ExitCode.success.code);

          verify(mockDirectory.path).called(1);
          verifyNoMoreInteractions(mockDirectory);

          verify(mockIDirectoryFactory.current).called(1);
          verifyNoMoreInteractions(mockIDirectoryFactory);

          verify(mockIFileManager.readJson(jsonFilePath())).called(1);
          verifyNoMoreInteractions(mockIFileManager);

          verifySendNotification(mockIFcmService: mockIFcmService).called(1);
          verifyNoMoreInteractions(mockIFcmService);

          verify(mockILogger.info(
            FCMTesterMessage.sendNotificationSuccess,
          )).called(1);
          verifyNoMoreInteractions(mockILogger);
        },
      );
    },
  );

  group(
    'Failire cases',
    () {
      test(
        'shoule return ${ExitCode.usage.code} and pring error message when json file not found.',
        () async {
          // Arrange

          when(mockILogger.error(
            FCMTesterMessage.jsonNotFound,
          )).thenReturn(null);

          when(mockIFileManager.readJson(jsonFilePath())).thenAnswer(
            (_) async => left(FileManagerFailure.fileNotFound()),
          );

          // Act
          final result = await sut.run([command]);

          // Assert
          expect(result, ExitCode.usage.code);

          verify(mockDirectory.path).called(1);
          verifyNoMoreInteractions(mockDirectory);

          verify(mockIDirectoryFactory.current).called(1);
          verifyNoMoreInteractions(mockIDirectoryFactory);

          verify(mockILogger.error(FCMTesterMessage.jsonNotFound)).called(1);
          verifyNoMoreInteractions(mockILogger);

          verify(mockIFileManager.readJson(jsonFilePath())).called(1);
          verifyNoMoreInteractions(mockIFileManager);
        },
      );
      test(
        'shoule return ${ExitCode.unavailable.code} and pring error message try read json and return unknown error.',
        () async {
          // Arrange

          when(mockILogger.error(
            FCMTesterMessage.unknownError,
          )).thenReturn(null);

          when(mockIFileManager.readJson(jsonFilePath())).thenAnswer(
            (_) async => left(FileManagerFailure.unknown(null)),
          );

          // Act
          final result = await sut.run([command]);

          // Assert
          expect(result, ExitCode.unavailable.code);

          verify(mockDirectory.path).called(1);
          verifyNoMoreInteractions(mockDirectory);

          verify(mockIDirectoryFactory.current).called(1);
          verifyNoMoreInteractions(mockIDirectoryFactory);

          verify(mockILogger.error(FCMTesterMessage.unknownError)).called(1);
          verifyNoMoreInteractions(mockILogger);

          verify(mockIFileManager.readJson(jsonFilePath())).called(1);
          verifyNoMoreInteractions(mockIFileManager);

          verifyZeroInteractions(mockIFcmService);
        },
      );
      test(
        'shoule return ${ExitCode.usage.code} and pring error message when sendNotification return left.',
        () async {
          // Arrange

          when(mockILogger.error(
            FCMTesterMessage.unknownError,
          )).thenReturn(null);

          when(mockIFileManager.readJson(jsonFilePath())).thenAnswer(
            (_) async => right(jsonReuest),
          );

          final fcmFailire = 'error message';

          whenSendNotification(
            mockIFcmService: mockIFcmService,
          ).thenAnswer(
            (_) async => left(fcmFailire),
          );

          // Act
          final result = await sut.run([command]);

          // Assert
          expect(result, ExitCode.usage.code);

          verify(mockDirectory.path).called(1);
          verifyNoMoreInteractions(mockDirectory);

          verify(mockIDirectoryFactory.current).called(1);
          verifyNoMoreInteractions(mockIDirectoryFactory);

          verify(mockILogger.error(fcmFailire)).called(1);
          verifyNoMoreInteractions(mockILogger);

          verify(mockIFileManager.readJson(jsonFilePath())).called(1);
          verifyNoMoreInteractions(mockIFileManager);

          verifySendNotification(mockIFcmService: mockIFcmService).called(1);
          verifyNoMoreInteractions(mockIFcmService);
        },
      );

      for (var value in invalidJsonServerKeyCases) {
        test(
          'shoule return ${ExitCode.usage.code} and pring invalid server key when ${value.when}',
          () async {
            // Arrange

            when(mockILogger.error(
              FCMTesterMessage.invlidServerKey,
            )).thenReturn(null);

            when(mockIFileManager.readJson(jsonFilePath())).thenAnswer(
              (_) async => right(value.request),
            );

            // Act
            final result = await sut.run([command]);

            // Assert
            expect(result, ExitCode.usage.code);

            verify(mockDirectory.path).called(1);
            verifyNoMoreInteractions(mockDirectory);

            verify(mockIDirectoryFactory.current).called(1);
            verifyNoMoreInteractions(mockIDirectoryFactory);

            verify(mockILogger.error(
              FCMTesterMessage.invlidServerKey,
            )).called(1);
            verifyNoMoreInteractions(mockILogger);

            verify(mockIFileManager.readJson(jsonFilePath())).called(1);
            verifyNoMoreInteractions(mockIFileManager);

            verifyZeroInteractions(mockIFcmService);
          },
        );
      }
      for (var value in invalidJsonRequestCases) {
        test(
          'shoule return ${ExitCode.usage.code} and pring invalid request when ${value.when}',
          () async {
            // Arrange

            when(mockILogger.error(
              FCMTesterMessage.invalidData,
            )).thenReturn(null);

            when(mockIFileManager.readJson(jsonFilePath())).thenAnswer(
              (_) async => right(value.request),
            );

            // Act
            final result = await sut.run([command]);

            // Assert
            expect(result, ExitCode.usage.code);

            verify(mockDirectory.path).called(1);
            verifyNoMoreInteractions(mockDirectory);

            verify(mockIDirectoryFactory.current).called(1);
            verifyNoMoreInteractions(mockIDirectoryFactory);

            verify(mockILogger.error(
              FCMTesterMessage.invalidData,
            )).called(1);
            verifyNoMoreInteractions(mockILogger);

            verify(mockIFileManager.readJson(jsonFilePath())).called(1);
            verifyNoMoreInteractions(mockIFileManager);

            verifyZeroInteractions(mockIFcmService);
          },
        );
      }
    },
  );
}
