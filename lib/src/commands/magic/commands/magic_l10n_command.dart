import 'dart:async';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as path;
import 'package:presto_cli/presto_cli.dart';
import 'package:presto_cli/src/utils/magic_lancher_strategies.dart';

class MagicL10NCommand extends Command<int> {
  MagicL10NCommand({
    required IMagicLauncher magicLauncher,
  }) : _magicLauncher = magicLauncher;

  final IMagicLauncher _magicLauncher;

  @override
  String get name => 'l10n';

  @override
  String get description => '';

  Future<bool> _packageWhere(Directory dir) async {
    final pubspec = File(path.join(dir.path, 'l10n.yaml'));
    return pubspec.existsSync();
  }

  @override
  Future<int> run() async {
    return await _magicLauncher.launch(
      magicCommandStrategy: MagicL10NStrategy(),
      packageWhere: (dir) async => _packageWhere(dir),
    );
  }
}
