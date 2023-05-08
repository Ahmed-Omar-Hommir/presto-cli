import 'package:args/command_runner.dart';
import 'package:presto_cli/logger.dart';
import 'package:presto_cli/package_manager.dart';

import 'commands/commands.dart';

class MakeCommand extends Command {
  MakeCommand() {
    addSubcommand(BuildRunnerCommand());
    addSubcommand(MagicRunnerCommand(
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
