import 'package:args/command_runner.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:presto_cli/src/logger.dart';

import 'commands/commands.dart';

class MakeCommand extends Command<int> {
  MakeCommand() {
    addSubcommand(MagicRunnerCommand(
      flutterCli: FlutterCLI(),
      fileManager: FileManager(),
      processLogger: ProcessLogger(),
      logger: Logger(),
      projectChecker: ProjectChecker(
        fileManager: FileManager(),
      ),
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
