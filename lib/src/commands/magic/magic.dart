import 'package:args/command_runner.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:presto_cli/src/logger.dart';

import 'commands/commands.dart';
import 'commands/magic_clean_command.dart';
import 'commands/magic_get_command.dart';
import 'commands/magic_l10n_command.dart';

class MakeCommand extends Command<int> {
  MakeCommand() {
    addSubcommand(MagicRunnerCommand(
      magicLauncher: MagicLauncher(
        processLogger: ProcessLogger(),
        fileManager: FileManager(),
        logger: Logger(),
        tasksRunner: TaskRunner(),
      ),
    ));
    addSubcommand(MagicCleanCommand(
      magicLauncher: MagicLauncher(
        processLogger: ProcessLogger(),
        fileManager: FileManager(),
        logger: Logger(),
        tasksRunner: TaskRunner(),
      ),
    ));
    addSubcommand(MagicGetCommand(
      magicLauncher: MagicLauncher(
        processLogger: ProcessLogger(),
        fileManager: FileManager(),
        logger: Logger(),
        tasksRunner: TaskRunner(),
      ),
    ));
    addSubcommand(MagicL10NCommand(
      magicLauncher: MagicLauncher(
        processLogger: ProcessLogger(),
        fileManager: FileManager(),
        logger: Logger(),
        tasksRunner: TaskRunner(),
      ),
    ));
  }
  @override
  String get name => 'magic';

  @override
  String get description => 'Execute common jobs in presto project.';
}
