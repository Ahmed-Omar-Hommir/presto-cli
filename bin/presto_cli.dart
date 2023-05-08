import 'package:args/command_runner.dart';
import 'package:presto_cli/commands/create/create.dart';
import 'package:presto_cli/commands/make/make.dart';
import 'package:presto_cli/dependency_composer.dart';

void main(List<String> args) async {
  final dependencyComposer = DependencyComposer();
  final logger = dependencyComposer.logger();

  final runner =
      CommandRunner('presto_cli', 'Manage all packages in the project.')
        ..addCommand(CreateCommand())
        ..addCommand(MakeCommand());

  try {
    await runner.run(args);
  } catch (e) {
    if (e is UsageException) {
      logger.err(e.message);
      logger.info(e.usage);
    }
  }
}
