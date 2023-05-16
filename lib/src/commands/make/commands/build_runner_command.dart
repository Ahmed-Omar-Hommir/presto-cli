import 'dart:async';
import 'package:args/command_runner.dart';

class BuildRunnerCommand extends Command<int> {
  BuildRunnerCommand() {
    argParser.addFlag(
      'delete-conflicting-outputs',
      help:
          'it tells the build system to delete any generated output files that already exist and have conflicting content before starting a new build. This can be useful to ensure that the generated files are up-to-date and consistent with the current build configuration.',
      abbr: 'd',
      negatable: false,
    );

    // --all, to generate all packages in sub dir.
    // -e, to execlude multiple packages by name
  }
  @override
  String get name => 'build_runner';

  @override
  List<String> get aliases => ['b'];

  @override
  String get description => 'generating files';
}
