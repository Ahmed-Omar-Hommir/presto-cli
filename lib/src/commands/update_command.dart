import 'dart:async';
import 'dart:io';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:http/http.dart' as http;
import 'package:args/command_runner.dart';
import 'package:dartz/dartz.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:presto_cli/src/version.dart';
import 'package:path/path.dart';

Future<Either<None, String>> get _sdkPath async {
  try {
    final isWindows = Platform.isWindows;
    final command = isWindows ? 'where' : 'which';
    final arguments = isWindows ? ['flutter'] : ['-a', 'flutter'];
    final processResult = await Process.run(command, arguments);

    final String flutterPath = processResult.stdout
        .toString()
        .split('\n')
        .map((path) => path.trim())
        .where((path) => path.isNotEmpty)
        .first;

    final flutterFile = File(flutterPath);

    final path = flutterFile.parent.path;

    return right('$path\\cache\\dart-sdk');
  } catch (e) {
    print(e);
    return left(const None());
  }
}

class UpdateCommand extends Command {
  @override
  String get name => 'update';

  @override
  String get description => 'Update cli to the latest version';

  @override
  FutureOr? run() async {
    final logger = Logger();
    final progress = logger.progress('Checking for updates...');
    final repository = "https://gitlab.com/Ahmed-Omar-Prestoeat/presto_cli";
    final pathToDartVersion = "/-/raw/main/lib/src/version.dart";

    // Make an HTTP request to the URI
    final response = await http.get(Uri.parse('$repository$pathToDartVersion'));

    // Create a temporary file
    final tempDir = await Directory.systemTemp.createTemp();
    final tempFile = File(join(tempDir.path, 'version.dart'));

    // Write the response content to the temporary file
    await tempFile.writeAsBytes(response.bodyBytes);

    final path = tempFile.path;

    final sdkPath = await _sdkPath;

    late final AnalysisContextCollection contextCollection;

    contextCollection = AnalysisContextCollection(
      includedPaths: [path],
      resourceProvider: PhysicalResourceProvider.INSTANCE,
      sdkPath: sdkPath.fold((_) => null, (sdkPath) => sdkPath),
    );

    final context = contextCollection.contextFor(path);

    final result = await context.currentSession.getResolvedLibrary(path);

    String? latestVersion;

    if (result is ResolvedLibraryResult) {
      for (var value in result.element.units) {
        print(value.topLevelVariables.first);
      }

      latestVersion = result.element.definingCompilationUnit.topLevelVariables
          .firstWhere((element) => element.name == 'packageVersion')
          .computeConstantValue()
          ?.toStringValue();
    }

    logger.info('Current version: $packageVersion');
    logger.info('Lates version: $latestVersion');

    if (latestVersion == null) {
      progress.cancel();
      logger.err("Cannot get latest version");
      exit(1);
    }

    if (latestVersion == packageVersion) {
      progress.cancel();
      logger.info("You are already on the latest version: $packageVersion");
      exit(0);
    }

    progress.update('Updating...');
    final process = await Process.start('dart', [
      'pub',
      'global',
      'activate',
      '--source',
      'git',
      repository,
    ]);

    final exitCode = await process.exitCode;

    if (exitCode == 0) {
      progress.update('Updated successfully');
      progress.cancel();
      exit(0);
    } else {
      progress.cancel();
      logger.err('Failed to update');
      exit(1);
    }
  }
}
