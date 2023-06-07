import 'dart:io';
import 'package:mason/mason.dart';
import 'package:mockito/annotations.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:presto_cli/src/logger.dart';
import 'package:presto_cli/src/utils/dart_cli.dart';
import 'package:presto_cli/src/utils/magic_lancher_strategies.dart';

@GenerateMocks([
  IDirectoryFactory,
  ILogger,
  IFileManager,
  IFileFactory,
  IYamlWrapper,
  File,
  Directory,
  IProcessManager,
  Process,
  ProcessResult,
  IFlutterCLI,
  IProjectChecker,
  IMagicCommandStrategy,
  IProcessLogger,
  IFcmService,
  FcmRemoteServiceApi,
  CliRemoteServiceApi,
  CliService,
  Progress,
  IDartCLI,
])
void setupMocks() {}
