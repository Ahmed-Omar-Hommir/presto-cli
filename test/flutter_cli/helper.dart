import 'dart:io';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart';
import 'package:presto_cli/presto_cli.dart';

void setUpProcessResult(
  ProcessResult processResult, {
  int exitCode = 0,
  String stdout = 'stdout',
  String stderr = 'stderr',
  int pid = 0,
}) {
  when(processResult.stdout).thenReturn(stdout);
  when(processResult.stderr).thenReturn(stderr);
  when(processResult.pid).thenReturn(pid);
  when(processResult.exitCode).thenReturn(exitCode);
}

Future<void> createPubspecFile(String packagePath) async {
  final pubspecFile = File(join(packagePath, 'pubspec.yaml'));
  await pubspecFile.writeAsString('name: test');
}

void whenRunPubAdd({
  required IProcessManager processManager,
  required ProcessResult answer,
  required List<String> dependencies,
}) {
  when(processManager.run(
    'flutter',
    ['pub', 'add', ...dependencies],
    workingDirectory: anyNamed('workingDirectory'),
  )).thenAnswer((_) async => answer);
}

VerificationResult verifyPubAdd({
  required IProcessManager processManager,
  required String packagePath,
  required List<String> dependencies,
}) {
  return verify(
    processManager.run(
      'flutter',
      ['pub', 'add', ...dependencies],
      workingDirectory: packagePath,
    ),
  );
}

class DependencyA {
  static const String name = 'dependencyA';
  static const String version = '^1.0.0';
  static const String dependency = '$name:$version';
}

class DependencyB {
  static const String name = 'dependencyB';
  static const String version = '^2.0.0';
  static const String dependency = '$name:$version';
}

class DependencyC {
  static const String name = 'dependencyC';
  static const String version = '^3.0.0';
  static const String dependency = '$name:$version';
}
