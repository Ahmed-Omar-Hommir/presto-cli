import 'package:args/command_runner.dart';
import 'package:cli/commands/package_manager.dart';
import 'package:cli/commands/user_input.dart';

import 'commands/commands.dart';
import 'commands/feature_command.dart';

class CreateCommand extends Command {
  CreateCommand() {
    addSubcommand(CreatePackageCommand(packageManager: PackageManager()));
    addSubcommand(CreateFeatureCommand(
      locTemp: LocalizationTemp(),
      featTemp: FeaturePackageTemp(),
      userInput: UserInput(),
      packageManager: PackageManager(),
      featBlocTemp: FeatureBlocTemp(),
    ));
  }
  @override
  String get name => 'create';

  @override
  String get description => 'create (package, template) in project';
}
