// Mocks generated by Mockito 5.4.0 from annotations
// in presto_cli/test/magic_runner_command/magic_runner_command_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;
import 'dart:io' as _i6;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mason/mason.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:presto_cli/src/logger.dart' as _i9;
import 'package:presto_cli/src/models/file_manager/file_manager_failure.dart'
    as _i8;
import 'package:presto_cli/src/models/flutter_cli/cli_failure.dart' as _i11;
import 'package:presto_cli/src/models/package_dependency.dart' as _i13;
import 'package:presto_cli/src/models/process/process_response.dart' as _i12;
import 'package:presto_cli/src/package_manager.dart' as _i4;
import 'package:presto_cli/src/utils/file_manager.dart' as _i7;
import 'package:presto_cli/src/utils/flutter_cli.dart' as _i10;

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

class _FakeProgress_1 extends _i1.SmartFake implements _i3.Progress {
  _FakeProgress_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [PackageManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockPackageManager extends _i1.Mock implements _i4.PackageManager {
  MockPackageManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<void> addDependencies({
    required String? packagePath,
    required Map<String, dynamic>? dependencies,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addDependencies,
          [],
          {
            #packagePath: packagePath,
            #dependencies: dependencies,
          },
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
  @override
  _i5.Future<void> addDevDependencies({
    required String? packagePath,
    required Map<String, dynamic>? dependencies,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addDevDependencies,
          [],
          {
            #packagePath: packagePath,
            #dependencies: dependencies,
          },
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
  @override
  _i5.Future<List<String>> findPackages({required _i6.Directory? dir}) =>
      (super.noSuchMethod(
        Invocation.method(
          #findPackages,
          [],
          {#dir: dir},
        ),
        returnValue: _i5.Future<List<String>>.value(<String>[]),
      ) as _i5.Future<List<String>>);
  @override
  _i5.Future<List<_i4.GenerateInfo>> packagesGenerateInfo(
          {required List<String>? dirs}) =>
      (super.noSuchMethod(
        Invocation.method(
          #packagesGenerateInfo,
          [],
          {#dirs: dirs},
        ),
        returnValue:
            _i5.Future<List<_i4.GenerateInfo>>.value(<_i4.GenerateInfo>[]),
      ) as _i5.Future<List<_i4.GenerateInfo>>);
  @override
  _i5.Future<List<_i6.File>> dartFilesCollection(
          {required _i6.Directory? dir}) =>
      (super.noSuchMethod(
        Invocation.method(
          #dartFilesCollection,
          [],
          {#dir: dir},
        ),
        returnValue: _i5.Future<List<_i6.File>>.value(<_i6.File>[]),
      ) as _i5.Future<List<_i6.File>>);
  @override
  _i5.Future<_i2.Either<_i2.None<dynamic>, String>> sdkPath() =>
      (super.noSuchMethod(
        Invocation.method(
          #sdkPath,
          [],
        ),
        returnValue: _i5.Future<_i2.Either<_i2.None<dynamic>, String>>.value(
            _FakeEither_0<_i2.None<dynamic>, String>(
          this,
          Invocation.method(
            #sdkPath,
            [],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i2.None<dynamic>, String>>);
}

/// A class which mocks [IFileManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockIFileManager extends _i1.Mock implements _i7.IFileManager {
  MockIFileManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<List<String>> findFilesByExtension(
    String? extension, {
    String? path,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #findFilesByExtension,
          [extension],
          {#path: path},
        ),
        returnValue: _i5.Future<List<String>>.value(<String>[]),
      ) as _i5.Future<List<String>>);
  @override
  _i5.Future<_i2.Either<_i8.FileManagerFailure, Map<dynamic, dynamic>>>
      readYaml(String? path) => (super.noSuchMethod(
            Invocation.method(
              #readYaml,
              [path],
            ),
            returnValue: _i5.Future<
                    _i2.Either<_i8.FileManagerFailure,
                        Map<dynamic, dynamic>>>.value(
                _FakeEither_0<_i8.FileManagerFailure, Map<dynamic, dynamic>>(
              this,
              Invocation.method(
                #readYaml,
                [path],
              ),
            )),
          ) as _i5.Future<
              _i2.Either<_i8.FileManagerFailure, Map<dynamic, dynamic>>>);
  @override
  _i5.Future<
      _i2.Either<_i8.FileManagerFailure, Set<_i6.Directory>>> findPackages(
          _i6.Directory? dir) =>
      (super.noSuchMethod(
        Invocation.method(
          #findPackages,
          [dir],
        ),
        returnValue: _i5.Future<
                _i2.Either<_i8.FileManagerFailure, Set<_i6.Directory>>>.value(
            _FakeEither_0<_i8.FileManagerFailure, Set<_i6.Directory>>(
          this,
          Invocation.method(
            #findPackages,
            [dir],
          ),
        )),
      ) as _i5.Future<_i2.Either<_i8.FileManagerFailure, Set<_i6.Directory>>>);
}

/// A class which mocks [ILogger].
///
/// See the documentation for Mockito's code generation for more information.
class MockILogger extends _i1.Mock implements _i9.ILogger {
  MockILogger() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void error(String? message) => super.noSuchMethod(
        Invocation.method(
          #error,
          [message],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void info(String? message) => super.noSuchMethod(
        Invocation.method(
          #info,
          [message],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void warn(String? message) => super.noSuchMethod(
        Invocation.method(
          #warn,
          [message],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void write(String? message) => super.noSuchMethod(
        Invocation.method(
          #write,
          [message],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i3.Progress progress(String? message) => (super.noSuchMethod(
        Invocation.method(
          #progress,
          [message],
        ),
        returnValue: _FakeProgress_1(
          this,
          Invocation.method(
            #progress,
            [message],
          ),
        ),
      ) as _i3.Progress);
}

/// A class which mocks [IFlutterCLI].
///
/// See the documentation for Mockito's code generation for more information.
class MockIFlutterCLI extends _i1.Mock implements _i10.IFlutterCLI {
  MockIFlutterCLI() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i2.Either<_i11.CliFailure, _i12.ProcessResponse>> pubAdd({
    required String? packagePath,
    required Set<_i13.PackageDependency>? dependencies,
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
            _i5.Future<_i2.Either<_i11.CliFailure, _i12.ProcessResponse>>.value(
                _FakeEither_0<_i11.CliFailure, _i12.ProcessResponse>(
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
      ) as _i5.Future<_i2.Either<_i11.CliFailure, _i12.ProcessResponse>>);
  @override
  _i5.Future<
      _i2.Either<_i11.CliFailure, _i12.ProcessResponse>> createNewPackage({
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
            _i5.Future<_i2.Either<_i11.CliFailure, _i12.ProcessResponse>>.value(
                _FakeEither_0<_i11.CliFailure, _i12.ProcessResponse>(
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
      ) as _i5.Future<_i2.Either<_i11.CliFailure, _i12.ProcessResponse>>);
  @override
  _i5.Future<_i2.Either<_i11.CliFailure, _i12.ProcessResponse>> genL10N(
          {String? packagePath}) =>
      (super.noSuchMethod(
        Invocation.method(
          #genL10N,
          [],
          {#packagePath: packagePath},
        ),
        returnValue:
            _i5.Future<_i2.Either<_i11.CliFailure, _i12.ProcessResponse>>.value(
                _FakeEither_0<_i11.CliFailure, _i12.ProcessResponse>(
          this,
          Invocation.method(
            #genL10N,
            [],
            {#packagePath: packagePath},
          ),
        )),
      ) as _i5.Future<_i2.Either<_i11.CliFailure, _i12.ProcessResponse>>);
  @override
  _i5.Future<_i2.Either<_i11.CliFailure, _i12.ProcessResponse>> buildRunner(
    _i6.Directory? workingDirectory, {
    bool? deleteConflictingOutputs = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #buildRunner,
          [workingDirectory],
          {#deleteConflictingOutputs: deleteConflictingOutputs},
        ),
        returnValue:
            _i5.Future<_i2.Either<_i11.CliFailure, _i12.ProcessResponse>>.value(
                _FakeEither_0<_i11.CliFailure, _i12.ProcessResponse>(
          this,
          Invocation.method(
            #buildRunner,
            [workingDirectory],
            {#deleteConflictingOutputs: deleteConflictingOutputs},
          ),
        )),
      ) as _i5.Future<_i2.Either<_i11.CliFailure, _i12.ProcessResponse>>);
}
