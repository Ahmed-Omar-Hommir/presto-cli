import 'dart:convert';
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

Future<Process> processWrapper(
  String executable,
  List<String> arguments, {
  required IProcessManager processManager,
  required String workingDirectory,
}) async {
  return processManager.start(
    executable,
    arguments,
    workingDirectory: workingDirectory,
    runInShell: true,
  );
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
  return when(processWrapper(
    'flutter',
    args,
    workingDirectory: workingDirectory.path,
    processManager: processManager,
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
  return verify(processWrapper(
    'flutter',
    args,
    workingDirectory: workingDirectory.path,
    processManager: processManager,
  ));
}

PostExpectation whenClean({
  required IProcessManager processManager,
  required Directory workingDirectory,
}) {
  return when(processWrapper(
    'flutter',
    ['clean'],
    workingDirectory: workingDirectory.path,
    processManager: processManager,
  ));
}

PostExpectation whenPubGet({
  required IProcessManager processManager,
  required Directory workingDirectory,
}) {
  return when(processWrapper(
    'flutter',
    ['pub', 'get'],
    workingDirectory: workingDirectory.path,
    processManager: processManager,
  ));
}

VerificationResult verifyPubGet({
  required IProcessManager processManager,
  required Directory workingDirectory,
}) {
  return verify(processWrapper(
    'flutter',
    ['pub', 'get'],
    workingDirectory: workingDirectory.path,
    processManager: processManager,
  ));
}

PostExpectation whenUpgrade({
  required IProcessManager processManager,
  required Directory workingDirectory,
}) {
  return when(processWrapper(
    'flutter',
    ['upgrade'],
    workingDirectory: workingDirectory.path,
    processManager: processManager,
  ));
}

VerificationResult verifyUpgrade({
  required IProcessManager processManager,
  required Directory workingDirectory,
}) {
  return verify(processWrapper(
    'flutter',
    ['upgrade'],
    workingDirectory: workingDirectory.path,
    processManager: processManager,
  ));
}

PostExpectation whenL10N({
  required IProcessManager processManager,
  required Directory workingDirectory,
}) {
  return when(processWrapper(
    'flutter',
    ['gen-l10n'],
    workingDirectory: workingDirectory.path,
    processManager: processManager,
  ));
}

VerificationResult verifyL10N({
  required IProcessManager processManager,
  required Directory workingDirectory,
}) {
  return verify(processWrapper(
    'flutter',
    ['gen-l10n'],
    workingDirectory: workingDirectory.path,
    processManager: processManager,
  ));
}

VerificationResult verifyClean({
  required IProcessManager processManager,
  required Directory workingDirectory,
}) {
  return verify(processWrapper(
    'flutter',
    ['clean'],
    workingDirectory: workingDirectory.path,
    processManager: processManager,
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
