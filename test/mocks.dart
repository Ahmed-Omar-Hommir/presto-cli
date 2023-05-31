import 'dart:io';
import 'package:mockito/annotations.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:presto_cli/src/logger.dart';
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
])
void setupMocks() {}
