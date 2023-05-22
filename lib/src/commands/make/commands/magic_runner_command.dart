import 'dart:async';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:presto_cli/src/logger.dart';
import 'package:presto_cli/src/utils/magic_lancher_strategies.dart';

class MagicRunnerCommand extends Command<int> {
  MagicRunnerCommand({
    required IMagicLauncher magicLauncher,
  }) : _magicLauncher = magicLauncher {
    argParser.addFlag(
      'delete-conflicting-outputs',
      help:
          'it tells the build system to delete any generated output files that already exist and have conflicting content before starting a new build. This can be useful to ensure that the generated files are up-to-date and consistent with the current build configuration.',
      abbr: 'd',
      negatable: false,
    );
  }

  final IMagicLauncher _magicLauncher;

  @override
  String get name => 'magic_runner';

  @override
  String get description =>
      'Generate files for all packages that depend on the build runner in the current/subdirectory';

  @override
  Future<int> run() async {
    return await _magicLauncher.launch(
      magicCommandStrategy: MagicBuildRunnerStrategy(),
    );
  }
}

abstract class LoggerMessage {
  static const String youAreNotInRootProject =
      'You are not in the root project.';
  static const String somethingWentWrong = 'Something went wrong.';
  static const String directoryNotFound = 'Directory not found.';
  static String dirNotFound(String dir) => 'Directory $dir not found.';
  static String noPackagesToProcess = 'No packages to process.';
}
