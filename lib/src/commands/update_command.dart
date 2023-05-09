import 'dart:async';
import 'dart:io';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:http/http.dart' as http;
import 'package:args/command_runner.dart';
import 'package:dartz/dartz.dart';
import 'package:presto_cli/src/package_manager.dart';

Future<Either<None, String>> get _sdkPath async {
  try {
    final command = Platform.isWindows ? 'where' : 'which';
    final processResult = await Process.run(command, ['flutter']);

    final String flutterPath = processResult.stdout.trim();

    final flutterFile = File(flutterPath);

    return right('${flutterFile.parent.path}/cache/dart-sdk');
  } catch (e) {
    return left(const None());
  }
}

class UpdateCommand extends Command {
  UpdateCommand();

  final IPackageManager _packageManager = PackageManager();
  @override
  String get name => 'update';

  @override
  String get description => 'Update cli to the latest version';

  @override
  FutureOr? run() async {
    final repository = "https://gitlab.com/Ahmed-Omar-Prestoeat/presto_cli";
    final pathToDartVersion = "/-/raw/main/lib/src/version.dart";

    // Make an HTTP request to the URI
    final response = await http.get(Uri.parse('$repository$pathToDartVersion'));

    // Create a temporary file
    final tempDir = await Directory.systemTemp.createTemp();
    final tempFile = File('${tempDir.path}/version.dart');

    // Write the response content to the temporary file
    await tempFile.writeAsBytes(response.bodyBytes);

    final path = tempFile.path;

    final sdkPath = await _sdkPath;
    print(sdkPath);
    AnalysisContextCollection contextCollection = AnalysisContextCollection(
      includedPaths: [path],
      resourceProvider: PhysicalResourceProvider.INSTANCE,
      sdkPath: sdkPath.fold(
        (_) => exit(1),
        (path) => path,
      ),
    );

    final context = contextCollection.contextFor(path);

    final result = await context.currentSession.getResolvedLibrary(path);

    if (result is ResolvedLibraryResult) {
      for (var value in result.element.units) {
        print(value.topLevelVariables.first);
      }

      final version = result.element.definingCompilationUnit.topLevelVariables
          .firstWhere((element) => element.name == 'packageVersion')
          .computeConstantValue()
          ?.toStringValue();
      print("Latest Version: $version");
    }

    // get current version
    // get latest version
    // compare
    // if latest > current
    // update by run command in terminal -> dart pub global activate --source git https://repo
  }
}
