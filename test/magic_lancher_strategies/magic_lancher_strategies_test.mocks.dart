// Mocks generated by Mockito 5.4.0 from annotations
// in presto_cli/test/magic_lancher_strategies/magic_lancher_strategies_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;
import 'dart:io' as _i8;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:presto_cli/src/models/flutter_cli/cli_failure.dart' as _i5;
import 'package:presto_cli/src/models/package_dependency.dart' as _i7;
import 'package:presto_cli/src/models/process/process_response.dart' as _i6;
import 'package:presto_cli/src/utils/flutter_cli.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [IFlutterCLI].
///
/// See the documentation for Mockito's code generation for more information.
class MockIFlutterCLI extends _i1.Mock implements _i3.IFlutterCLI {
  MockIFlutterCLI() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.CliFailure, _i6.ProcessResponse>> pubAdd({
    required String? packagePath,
    required Set<_i7.PackageDependency>? dependencies,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #pubAdd,
          [],
          {
            #packagePath: packagePath,
            #dependencies: dependencies,
          },
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.CliFailure, _i6.ProcessResponse>>.value(
                _FakeEither_0<_i5.CliFailure, _i6.ProcessResponse>(
          this,
          Invocation.method(
            #pubAdd,
            [],
            {
              #packagePath: packagePath,
              #dependencies: dependencies,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.CliFailure, _i6.ProcessResponse>>);
  @override
  _i4.Future<_i2.Either<_i5.CliFailure, _i6.ProcessResponse>> createNewPackage({
    required String? packageName,
    String? packagePath,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #createNewPackage,
          [],
          {
            #packageName: packageName,
            #packagePath: packagePath,
          },
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.CliFailure, _i6.ProcessResponse>>.value(
                _FakeEither_0<_i5.CliFailure, _i6.ProcessResponse>(
          this,
          Invocation.method(
            #createNewPackage,
            [],
            {
              #packageName: packageName,
              #packagePath: packagePath,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.CliFailure, _i6.ProcessResponse>>);
  @override
  _i4.Future<_i2.Either<_i5.CliFailure, _i6.ProcessResponse>> genL10N(
          {String? packagePath}) =>
      (super.noSuchMethod(
        Invocation.method(
          #genL10N,
          [],
          {#packagePath: packagePath},
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.CliFailure, _i6.ProcessResponse>>.value(
                _FakeEither_0<_i5.CliFailure, _i6.ProcessResponse>(
          this,
          Invocation.method(
            #genL10N,
            [],
            {#packagePath: packagePath},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.CliFailure, _i6.ProcessResponse>>);
  @override
  _i4.Future<_i2.Either<_i5.CliFailure, _i8.Process>> buildRunner(
    _i8.Directory? workingDirectory, {
    bool? deleteConflictingOutputs = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #buildRunner,
          [workingDirectory],
          {#deleteConflictingOutputs: deleteConflictingOutputs},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.CliFailure, _i8.Process>>.value(
            _FakeEither_0<_i5.CliFailure, _i8.Process>(
          this,
          Invocation.method(
            #buildRunner,
            [workingDirectory],
            {#deleteConflictingOutputs: deleteConflictingOutputs},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.CliFailure, _i8.Process>>);
  @override
  _i4.Future<_i2.Either<_i5.CliFailure, _i8.Process>> clean(
          _i8.Directory? workingDirectory) =>
      (super.noSuchMethod(
        Invocation.method(
          #clean,
          [workingDirectory],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.CliFailure, _i8.Process>>.value(
            _FakeEither_0<_i5.CliFailure, _i8.Process>(
          this,
          Invocation.method(
            #clean,
            [workingDirectory],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.CliFailure, _i8.Process>>);
}