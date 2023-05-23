import 'dart:async';
import 'package:args/command_runner.dart';
import 'package:presto_cli/src/utils/magic_lancher_strategies.dart';
import 'package:presto_cli/src/utils/utils.dart';

class MagicUpgradeCommand extends Command<int> {
  MagicUpgradeCommand({
    required IMagicLauncher magicLauncher,
  }) : _magicLauncher = magicLauncher;

  final IMagicLauncher _magicLauncher;

  @override
  String get name => 'upgrade';

  @override
  String get description => '';

  @override
  Future<int> run() async {
    return await _magicLauncher.launch(
      magicCommandStrategy: MagicUpgradeStrategy(),
    );
  }
}
