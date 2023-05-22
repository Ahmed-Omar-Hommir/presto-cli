import 'dart:async';
import 'package:args/command_runner.dart';
import 'package:presto_cli/src/utils/magic_lancher_strategies.dart';
import 'package:presto_cli/src/utils/utils.dart';

class MagicGetCommand extends Command<int> {
  MagicGetCommand({
    required IMagicLauncher magicLauncher,
  }) : _magicLauncher = magicLauncher;

  final IMagicLauncher _magicLauncher;

  @override
  String get name => 'magic_get';

  @override
  String get description => '';

  @override
  Future<int> run() async {
    return await _magicLauncher.launch(
      magicCommandStrategy: MagicGetStrategy(),
    );
  }
}
