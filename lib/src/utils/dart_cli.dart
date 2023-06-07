import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presto_cli/presto_cli.dart';

abstract class IDartCLI {
  Future<Either<CliFailure, Process>> installCliFromRepository({
    required String url,
  });
}

class DartCLI implements IDartCLI {
  DartCLI({
    @visibleForTesting IProcessManager? processManager,
  }) : _processManager = processManager ?? ProcessManager();

  final IProcessManager _processManager;

  @override
  Future<Either<CliFailure, Process>> installCliFromRepository({
    required String url,
  }) async {
    try {
      final result = await _processManager.start(
        'dart',
        [
          'pub',
          'global',
          'activate',
          '--source',
          'git',
          RemoteRepositoryInfo.url,
        ],
        runInShell: true,
      );

      return Right(result);
    } catch (e) {
      return left(CliFailure.unknown(e));
    }
  }
}
