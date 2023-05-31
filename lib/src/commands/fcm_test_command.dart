import 'dart:async';
import 'package:args/command_runner.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:presto_cli/src/logger.dart';

class FCMTestCommand extends Command<int> {
  FCMTestCommand({
    @visibleForTesting IDirectoryFactory? directoryFactory,
    required IFcmService fcmService,
    required ILogger logger,
    required IFileManager fileManager,
  })  : _directoryFactory = directoryFactory ?? const DirectoryFactory(),
        _logger = logger,
        _fcmService = fcmService,
        _fileManager = fileManager;

  final IDirectoryFactory _directoryFactory;
  final ILogger _logger;
  final IFileManager _fileManager;
  final IFcmService _fcmService;

  @override
  String get name => 'fcm-test';

  @override
  String get description =>
      'Tests FCM push notifications. Requires a JSON file (fcm_test.json) with server key and request data.';

  @override
  Future<int> run() async {
    final jsonResunlt = await _fileManager.readJson(join(
      _directoryFactory.current.path,
      'fcm_test.json',
    ));

    return jsonResunlt.fold(
      (failure) {
        return failure.maybeMap(
          fileNotFound: (value) {
            _logger.error(FCMTesterMessage.jsonNotFound);
            return ExitCode.usage.code;
          },
          orElse: () {
            _logger.error(FCMTesterMessage.unknownError);
            return ExitCode.unavailable.code;
          },
        );
      },
      (jsonRequest) async {
        final serverKey = jsonRequest['serverKey'];
        final data = jsonRequest['request'];

        if (serverKey == null || serverKey is! String || serverKey.isEmpty) {
          _logger.error(FCMTesterMessage.invlidServerKey);
          return ExitCode.usage.code;
        }

        if (data == null || data is! Map<String, dynamic> || data.isEmpty) {
          _logger.error(FCMTesterMessage.invalidData);
          return ExitCode.usage.code;
        }

        final result = await _fcmService.sendNotification(
          data: data,
          serverKey: serverKey,
        );

        return result.fold(
          (failire) {
            _logger.error(failire);
            return ExitCode.usage.code;
          },
          (response) {
            _logger.info(FCMTesterMessage.sendNotificationSuccess);
            return ExitCode.success.code;
          },
        );
      },
    );
  }
}

abstract class FCMTesterMessage {
  static String get jsonNotFound => 'json file not found.';
  static String get unknownError =>
      'unknown error when trying reading json file.';
  static String get invlidServerKey => 'invalid server key.';
  static String get invalidData => 'invalid data.';
  static String get sendNotificationSuccess =>
      'send notification successfully.';
}
