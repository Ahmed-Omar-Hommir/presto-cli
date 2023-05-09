import 'dart:async';
import 'package:args/command_runner.dart';
import 'package:presto_cli/src/package_manager.dart';

class UpdateCommand extends Command {
  UpdateCommand();

  final IPackageManager _packageManager = PackageManager();
  @override
  String get name => 'update';

  @override
  String get description => 'Update cli to the latest version';

  @override
  FutureOr? run() async {}
}
