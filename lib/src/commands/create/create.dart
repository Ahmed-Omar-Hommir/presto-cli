import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:presto_cli/src/commands/create/templates/feature_bloc_temp.dart';
import 'package:presto_cli/src/commands/create/templates/localization_temp.dart';
import 'package:presto_cli/src/commands/create/templates/set_up_feature_files_temp.dart';
import 'package:presto_cli/src/package_manager.dart';
import 'package:presto_cli/src/user_input.dart';

import 'commands/commands.dart';
import 'commands/feature_package_command.dart';

class CreateCommand extends Command {
  CreateCommand() {
    addSubcommand(CreateFeaturePackageCommand(
      flutterCli: FlutterCLI(),
      locTemp: LocalizationTemp(),
      featTemp: SetUpFeatureFilesTemp(),
      userInput: UserInput(),
      packageManager: PackageManager(),
      featBlocTemp: FeatureBlocTemp(),
      logger: Logger(),
    ));
  }
  @override
  String get name => 'create';

  @override
  String get description => 'Create packages suitable to your requirements.';
}
