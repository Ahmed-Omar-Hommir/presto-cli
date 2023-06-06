import 'dart:async';
import 'dart:io';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:http/http.dart' as http;
import 'package:args/command_runner.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:presto_cli/src/logger.dart';
import 'package:presto_cli/src/package_manager.dart';
import 'package:presto_cli/src/version.dart';
import 'package:path/path.dart';

class UpdateCommand extends Command<int> {
  UpdateCommand({
    required IPackageManager packageManager,
    required ILogger logger,
  })  : _packageManager = packageManager,
        _logger = logger;

  final IPackageManager _packageManager;
  final ILogger _logger;

  @override
  String get name => 'update';

  @override
  String get description => 'Update cli to the latest version';

  @override
  Future<int> run() async {
    // Check for updates
    // If there is an update, update the cli
    // If there is no update, exit

    throw UnimplementedError();

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
