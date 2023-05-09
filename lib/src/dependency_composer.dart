import 'package:mason/mason.dart';
import 'package:presto_cli/src/package_manager.dart';

abstract class IDependencyComposer {
  Logger logger();
  IPackageManager packageManager();
}

class DependencyComposer implements IDependencyComposer {
  @override
  Logger logger() => Logger();

  @override
  IPackageManager packageManager() => PackageManager();
}
