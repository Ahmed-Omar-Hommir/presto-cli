import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presto_cli/presto_cli.dart';

abstract class IMagicCommandStrategy {
  Future<Either<CliFailure, Process>> runCommand(Directory dir);
}

class MagicBuildRunnerStrategy implements IMagicCommandStrategy {
  MagicBuildRunnerStrategy({
    @visibleForTesting IFlutterCLI? flutterCLI,
    required bool deleteConflictingOutputs,
  })  : _flutterCLI = flutterCLI ?? FlutterCLI(),
        _deleteConflictingOutputs = deleteConflictingOutputs;
  final IFlutterCLI _flutterCLI;
  final bool _deleteConflictingOutputs;
  @override
  Future<Either<CliFailure, Process>> runCommand(Directory dir) {
    return _flutterCLI.buildRunner(
      dir,
      deleteConflictingOutputs: _deleteConflictingOutputs,
    );
  }
}

class MagicCleanStrategy implements IMagicCommandStrategy {
  MagicCleanStrategy({
    @visibleForTesting IFlutterCLI? flutterCLI,
  }) : _flutterCLI = flutterCLI ?? FlutterCLI();
  final IFlutterCLI _flutterCLI;
  @override
  Future<Either<CliFailure, Process>> runCommand(Directory dir) {
    return _flutterCLI.clean(dir);
  }
}

class MagicGetStrategy implements IMagicCommandStrategy {
  MagicGetStrategy({
    @visibleForTesting IFlutterCLI? flutterCLI,
  }) : _flutterCLI = flutterCLI ?? FlutterCLI();
  final IFlutterCLI _flutterCLI;
  @override
  Future<Either<CliFailure, Process>> runCommand(Directory dir) {
    return _flutterCLI.pubGet(dir);
  }
}

class MagicL10NStrategy implements IMagicCommandStrategy {
  MagicL10NStrategy({
    @visibleForTesting IFlutterCLI? flutterCLI,
  }) : _flutterCLI = flutterCLI ?? FlutterCLI();
  final IFlutterCLI _flutterCLI;
  @override
  Future<Either<CliFailure, Process>> runCommand(Directory dir) {
    return _flutterCLI.genL10N(dir);
  }
}
