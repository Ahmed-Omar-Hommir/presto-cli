import 'dart:async';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:presto_cli/src/logger.dart';

class UpdateCommand extends Command<int> {
  UpdateCommand({
    required ICliService cliService,
    required ILogger logger,
  })  : _cliService = cliService,
        _logger = logger;

  final ILogger _logger;
  final ICliService _cliService;

  @override
  String get name => 'update';

  @override
  String get description => 'Update cli to the latest version';

  @override
  Future<int> run() async {
    // Check for updates

    final progress = _logger.progress(UpdateCommandMessage.checkingForUpdates);

    final lastVersionResult = await _cliService.getLastVersion();

    return lastVersionResult.fold(
      (failire) => throw UnimplementedError(),
      (lastVersion) {
        progress.update(UpdateCommandMessage.updating);
        progress.complete(UpdateCommandMessage.updated);
        return ExitCode.success.code;
      },
    );

    // If there is an update, update the cli
    // If there is no update, exit

    // try {
    //   final checkUpdateProgress = _logger.progress('Checking for updates');
    //   final pathToDartVersion = "/-/raw/main/lib/src/version.dart";

    //   // Make an HTTP request to the URI
    //   final response = await http.get(
    //     Uri.parse('${RemoteRepositoryInfo.versionUrl}$pathToDartVersion'),
    //   );

    //   // Create a temporary file
    //   final tempDir = await Directory.systemTemp.createTemp();
    //   final tempFile = File(join(tempDir.path, 'version.dart'));

    //   // Write the response content to the temporary file
    //   await tempFile.writeAsBytes(response.bodyBytes);

    //   final path = tempFile.path;

    //   final sdkPath = await _packageManager.sdkPath().then(
    //         (value) => value.fold(
    //           (_) {
    //             checkUpdateProgress.cancel();
    //             _logger.error('Cannot find sdk path');
    //             exit(1);
    //           },
    //           (sdkPath) => sdkPath,
    //         ),
    //       );

    //   final AnalysisContextCollection contextCollection =
    //       AnalysisContextCollection(
    //     includedPaths: [path],
    //     resourceProvider: PhysicalResourceProvider.INSTANCE,
    //     sdkPath: sdkPath,
    //   );

    //   final context = contextCollection.contextFor(path);

    //   final result = await context.currentSession.getResolvedLibrary(path);

    //   String? latestVersion;

    //   if (result is ResolvedLibraryResult) {
    //     latestVersion = result.element.definingCompilationUnit.topLevelVariables
    //         .firstWhere((element) => element.name == 'packageVersion')
    //         .computeConstantValue()
    //         ?.toStringValue();
    //   }

    //   if (latestVersion == null) {
    //     checkUpdateProgress.cancel();
    //     _logger.error("Cannot get latest version");
    //     exit(1);
    //   }

    //   checkUpdateProgress.complete('Checked for updates');

    //   if (latestVersion == packageVersion) {
    //     _logger.info("Presto CLI is already at the latest version.");
    //     exit(0);
    //   }

    //   final updatingProgress = _logger.progress('Updating to $latestVersion');

    //   final process = await Process.start('dart', [
    //     'pub',
    //     'global',
    //     'activate',
    //     '--source',
    //     'git',
    //     RemoteRepositoryInfo.url,
    //   ]);

    //   final exitCode = await process.exitCode;

    //   if (exitCode == 0) {
    //     updatingProgress.complete('Updated to $latestVersion');
    //     exit(0);
    //   } else {
    //     updatingProgress.cancel();
    //     _logger.error('Failed to update');
    //     exit(1);
    //   }
    // } catch (e) {
    //   _logger.error(e.toString());
    //   exit(1);
    // }
  }
}

abstract class UpdateCommandMessage {
  static const String checkingForUpdates = 'Checking for updates';
  static const String checkedForUpdates = 'Checked for updates';
  static const String updating = 'Updating to';
  static const String updated = 'Updated to';
  static const String failedToUpdate = 'Failed to update';
  static const String alreadyLatestVersion =
      'Presto CLI is already at the latest version.';
}
