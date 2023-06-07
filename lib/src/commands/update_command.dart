import 'dart:async';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart' as mason;
import 'package:presto_cli/presto_cli.dart';
import 'package:presto_cli/src/logger.dart';
import 'package:presto_cli/src/utils/dart_cli.dart';
import 'package:presto_cli/src/version.dart';

class UpdateCommand extends Command<int> {
  UpdateCommand({
    required ICliService cliService,
    required ILogger logger,
    required IDartCLI dartCLI,
  })  : _cliService = cliService,
        _dartCLI = dartCLI,
        _logger = logger;

  final ILogger _logger;
  final ICliService _cliService;
  final IDartCLI _dartCLI;

  @override
  String get name => 'update';

  @override
  String get description => 'Update cli to the latest version';

  @override
  Future<int> run() async {
    try {
      final progress =
          _logger.progress(UpdateCommandMessage.checkingForUpdates);

      final lastVersionResult = await _cliService.getLastVersion();

      return await lastVersionResult.fold(
        (failire) {
          progress.cancel();
          _logger.error(failire);
          return mason.ExitCode.unavailable.code;
        },
        (lastVersion) async {
          if (lastVersion == packageVersion) {
            progress.complete(UpdateCommandMessage.alreadyLatestVersion);
            return mason.ExitCode.success.code;
          }
          progress.update(UpdateCommandMessage.updating(lastVersion));
          final response = await _dartCLI.installCliFromRepository(
            url: RemoteRepositoryInfo.url,
          );

          return await response.fold(
            (_) {
              _logger.error(UpdateCommandMessage.failedToUpdate);
              progress.cancel();
              return mason.ExitCode.unavailable.code;
            },
            (process) async {
              progress.complete(UpdateCommandMessage.updated(lastVersion));
              return await process.exitCode;
            },
          );
        },
      );
    } catch (e) {
      _logger.error(e.toString());
      return mason.ExitCode.unavailable.code;
    }
  }
}

abstract class UpdateCommandMessage {
  static const String checkingForUpdates = 'Checking for updates';
  static const String checkedForUpdates = 'Checked for updates';
  static String updating(String version) => 'Updating to $version';
  static String updated(String version) => 'Updated to $version';
  static const String failedToUpdate = 'Failed to update';
  static const String alreadyLatestVersion =
      'Presto CLI is already at the latest version.';
}
