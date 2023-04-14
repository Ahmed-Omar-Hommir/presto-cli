// import 'package:args/command_runner.dart';
// import 'package:cli/commands/package_manager.dart';
// import 'package:mason/mason.dart';

// import 'create/commands/create_package_command.dart';

// class CreateCommand extends Command {
//   CreateCommand() {
//     addSubcommand(CreatePackageCommand(packageManager: PackageManager()));
//   }
//   @override
//   String get name => 'create';

//   @override
//   String get description => 'create (package, template) in project';
// }

// Steps:
// - Ask Package Name.
// - Ask Package Type.
// - Create New Package.

// If Package Type Is Feature
// - Ask For Localization
// - Ask For Dependencies
// - Ask For Asset File

// If Package Type Is repository
// - Ask For Dependencies

// If Package Type Is Data Source
// - Ask For Dependencies
