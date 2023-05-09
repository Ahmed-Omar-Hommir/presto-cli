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

    return right('${flutterFile.parent.path}/cache/dart-sdk');
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
    final _logger = Logger();
    final progress = _logger.progress('Checking for updates...');
    final repository = "https://gitlab.com/Ahmed-Omar-Prestoeat/presto_cli";
    final pathToDartVersion = "/-/raw/main/lib/src/version.dart";

    // Make an HTTP request to the URI
    _logger.info("1");
    final response = await http.get(Uri.parse('$repository$pathToDartVersion'));

    // Create a temporary file
    _logger.info("2");
    final tempDir = await Directory.systemTemp.createTemp();
    _logger.info("3");
    final tempFile = File('${tempDir.path}/version.dart');

    // Write the response content to the temporary file
    _logger.info("4");
    await tempFile.writeAsBytes(response.bodyBytes);

    final path = tempFile.path;

    _logger.info("5");
    final sdkPath = await _sdkPath;
    _logger.info("SdkPath: $sdkPath");

    _logger.info("6");
    AnalysisContextCollection contextCollection = AnalysisContextCollection(
      includedPaths: [path],
      resourceProvider: PhysicalResourceProvider.INSTANCE,
      sdkPath: sdkPath.fold(
        (_) => exit(1),
        (path) => path,
      ),
    );

    _logger.info("7");
    final context = contextCollection.contextFor(path);

    _logger.info("8");
    final result = await context.currentSession.getResolvedLibrary(path);

    String? latestVersion;

    _logger.info("9");
    if (result is ResolvedLibraryResult) {
      for (var value in result.element.units) {
        print(value.topLevelVariables.first);
      }

      latestVersion = result.element.definingCompilationUnit.topLevelVariables
          .firstWhere((element) => element.name == 'packageVersion')
          .computeConstantValue()
          ?.toStringValue();
    }

    _logger.info('Current version: $packageVersion');
    _logger.info('Lates version: $latestVersion');

    if (latestVersion == null) {
      progress.cancel();
      _logger.err("Cannot get latest version");
      exit(1);
    }

    if (latestVersion == packageVersion) {
      progress.cancel();
      _logger.info("You are already on the latest version: $packageVersion");
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
      _logger.err('Failed to update');
      exit(1);
    }
  }
}
