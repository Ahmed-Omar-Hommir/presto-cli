import 'dart:io';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart';
import 'package:presto_cli/presto_cli.dart';

void whenProcessResult(
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
  required String packagePath,
}) {
  when(processManager.run(
    'flutter',
    ['pub', 'add', ...dependencies],
    workingDirectory: packagePath,
  )).thenAnswer((_) async => answer);
}

PostExpectation whenCreateNewPackage({
  required IProcessManager processManager,
  required String packageName,
  required String packagePath,
}) {
  return when(processManager.run(
    'flutter',
    [
      'create',
      '--template=package',
      packageName,
    ],
    workingDirectory: packagePath,
  ));
}

PostExpectation whenGenL10N({
  required IProcessManager processManager,
  required String packagePath,
}) {
  return when(processManager.run(
    'flutter',
    ['gen-l10n'],
    workingDirectory: packagePath,
  ));
}

PostExpectation whenBuildRunner({
  required IProcessManager processManager,
  required Directory workingDirectory,
  bool withDeleteConflictingOutputs = false,
}) {
  final args = ['pub', 'run', 'build_runner', 'build'];
  if (withDeleteConflictingOutputs) {
    args.add('--delete-conflicting-outputs');
  }
  return when(processManager.start(
    'flutter',
    args,
    workingDirectory: workingDirectory.path,
  ));
}

VerificationResult verifyBuildRunner({
  required IProcessManager processManager,
  required Directory workingDirectory,
  bool withDeleteConflictingOutputs = false,
}) {
  final args = ['pub', 'run', 'build_runner', 'build'];
  if (withDeleteConflictingOutputs) {
    args.add('--delete-conflicting-outputs');
  }
  return verify(processManager.start(
    'flutter',
    args,
    workingDirectory: workingDirectory.path,
  ));
}

PostExpectation whenClean({
  required IProcessManager processManager,
  required Directory workingDirectory,
}) {
  return when(processManager.start(
    'flutter',
    ['clean'],
    workingDirectory: workingDirectory.path,
  ));
}

PostExpectation whenPubGet({
  required IProcessManager processManager,
  required Directory workingDirectory,
}) {
  return when(processManager.start(
    'flutter',
    ['pub', 'get'],
    workingDirectory: workingDirectory.path,
  ));
}

VerificationResult verifyPubGet({
  required IProcessManager processManager,
  required Directory workingDirectory,
}) {
  return verify(processManager.start(
    'flutter',
    ['pub', 'get'],
    workingDirectory: workingDirectory.path,
  ));
}

PostExpectation whenUpgrade({
  required IProcessManager processManager,
  required Directory workingDirectory,
}) {
  return when(processManager.start(
    'flutter',
    ['upgrade'],
    workingDirectory: workingDirectory.path,
  ));
}

VerificationResult verifyUpgrade({
  required IProcessManager processManager,
  required Directory workingDirectory,
}) {
  return verify(processManager.start(
    'flutter',
    ['upgrade'],
    workingDirectory: workingDirectory.path,
  ));
}

PostExpectation whenL10N({
  required IProcessManager processManager,
  required Directory workingDirectory,
}) {
  return when(processManager.start(
    'flutter',
    ['gen-l10n'],
    workingDirectory: workingDirectory.path,
  ));
}

VerificationResult verifyL10N({
  required IProcessManager processManager,
  required Directory workingDirectory,
}) {
  return verify(processManager.start(
    'flutter',
    ['gen-l10n'],
    workingDirectory: workingDirectory.path,
  ));
}

VerificationResult verifyClean({
  required IProcessManager processManager,
  required Directory workingDirectory,
}) {
  return verify(processManager.start(
    'flutter',
    ['clean'],
    workingDirectory: workingDirectory.path,
  ));
}

VerificationResult verifyGenL10N({
  required IProcessManager processManager,
  required String packagePath,
}) {
  return verify(
    processManager.run(
      'flutter',
      ['gen-l10n'],
      workingDirectory: packagePath,
    ),
  );
}

VerificationResult verifyCreateNewPackage({
  required IProcessManager processManager,
  required String packageName,
  required String packagePath,
}) {
  return verify(
    processManager.run(
      'flutter',
      [
        'create',
        '--template=package',
        packageName,
      ],
      workingDirectory: packagePath,
    ),
  );
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
