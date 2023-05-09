import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:presto_cli/src/commands/commands.dart';
import 'package:presto_cli/src/dependency_composer.dart';
import 'package:presto_cli/src/version.dart';

void main(List<String> args) async {
  final dependencyComposer = DependencyComposer();
  final logger = dependencyComposer.logger();

  final runner =
      CommandRunner('presto_cli', 'Manage all packages in the project.')
        ..addCommand(CreateCommand())
        ..addCommand(MakeCommand())
        ..argParser.addFlag(
          'version',
          help: 'Print the current version.',
        );

  final result = runner.parse(args);

  if (result.wasParsed('version')) {
    logger.info(packageVersion);
    exit(0);
  }

  try {
    await runner.run(args);
  } catch (e) {
    if (e is UsageException) {
      logger.err(e.message);
      logger.info(e.usage);
    }
  }
}
