import 'dart:io';

import 'package:presto_cli/presto_cli.dart';

import 'magic_runner_command_test.mocks.dart';

const processResponse = ProcessResponse(
  stdout: 'stdout',
  stderr: 'stderr',
  exitCode: 0,
  pid: 0,
);

final Set<Directory> packageDirectories = {
  Directory('path_1'),
  Directory('path_2'),
  Directory('path_3'),
};

const magicRunnercommand = 'magic_runner';

Map<String, dynamic> yamlContent({
  String name = 'prestoeat',
}) =>
    {'name': name};

class MocksProvider {
  MocksProvider({
    required MockIFlutterCLI mockFlutterCLI,
    required MockIFileManager mockFileManager,
    required MockILogger mockLogger,
  })  : _mockFlutterCLI = mockFlutterCLI,
        _mockFileManager = mockFileManager,
        _mockLogger = mockLogger;

  final MockIFlutterCLI _mockFlutterCLI;
  final MockIFileManager _mockFileManager;
  final MockILogger _mockLogger;

  void allMocks({
    required void Function(MockIFlutterCLI mock) mockFlutterCli,
    required void Function(MockIFileManager mock) mockFileManager,
    required void Function(MockILogger mock) mockLogger,
  }) {
    mockFlutterCli(_mockFlutterCLI);
    mockFileManager(_mockFileManager);
    mockLogger(_mockLogger);
  }

  void mocks({
    void Function(MockIFlutterCLI mock)? mockFlutterCli,
    void Function(MockIFileManager mock)? mockFileManager,
    void Function(MockILogger mock)? mockLogger,
  }) {
    mockFlutterCli?.call(_mockFlutterCLI);
    mockFileManager?.call(_mockFileManager);
    mockLogger?.call(_mockLogger);
    if (mockFlutterCli == null &&
        mockFileManager == null &&
        mockLogger == null) {
      throw Exception('No mocks were provided.');
    }
  }
}
