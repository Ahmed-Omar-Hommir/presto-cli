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
  }) : _flutterCLI = flutterCLI ?? FlutterCLI();
  final IFlutterCLI _flutterCLI;
  @override
  Future<Either<CliFailure, Process>> runCommand(Directory dir) {
    return _flutterCLI.buildRunner(dir);
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
