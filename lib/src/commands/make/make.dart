import 'package:args/command_runner.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:presto_cli/src/logger.dart';
import 'package:presto_cli/src/package_manager.dart';

import 'commands/commands.dart';

class MakeCommand extends Command<int> {
  MakeCommand() {
    addSubcommand(MagicRunnerCommand(
      flutterCli: FlutterCLI(),
      fileManager: FileManager(),
      packageManager: PackageManager(),
      logger: Logger(),
    ));

    // addSubcommand(BuildYamlCommand(
    //   buildYamlGenerator: BuildYamlGenerator(
    //     packageManager: PackageManager(),
    //   ),
    //   logger: Logger(),
    // ));
  }
  @override
  String get name => 'make';

  @override
  String get description => 'Execute common jobs in presto project.';
}
