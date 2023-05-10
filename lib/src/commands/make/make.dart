import 'package:args/command_runner.dart';
import 'package:presto_cli/src/commands/update_command.dart';
import 'package:presto_cli/src/logger.dart';
import 'package:presto_cli/src/package_manager.dart';

import 'commands/commands.dart';

class MakeCommand extends Command {
  MakeCommand() {
    addSubcommand(BuildRunnerCommand());
    addSubcommand(MagicRunnerCommand(
      packageManager: PackageManager(),
      logger: Logger(),
    ));
    addSubcommand(UpdateCommand(
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
