import 'package:args/command_runner.dart';
import 'package:presto_cli/commands/create/create.dart';

void main(List<String> args) async {
  final runner =
      CommandRunner('pacakges', 'Manage all packages in the project.')
        ..addCommand(CreateCommand());

  await runner.run(args);
}
