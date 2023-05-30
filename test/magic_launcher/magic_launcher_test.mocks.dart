// Mocks generated by Mockito 5.4.0 from annotations
// in presto_cli/test/magic_launcher/magic_launcher_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;
import 'dart:io' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mason/mason.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:presto_cli/src/logger.dart' as _i8;
import 'package:presto_cli/src/models/file_manager/file_manager_failure.dart'
    as _i9;
import 'package:presto_cli/src/models/models.dart' as _i7;
import 'package:presto_cli/src/utils/magic_lancher_strategies.dart' as _i10;
import 'package:presto_cli/src/utils/utils.dart' as _i5;

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

class _FakeIOSink_2 extends _i1.SmartFake implements _i4.IOSink {
  _FakeIOSink_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDirectory_3 extends _i1.SmartFake implements _i4.Directory {
  _FakeDirectory_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [IProjectChecker].
///
/// See the documentation for Mockito's code generation for more information.
class MockIProjectChecker extends _i1.Mock implements _i5.IProjectChecker {
  MockIProjectChecker() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<_i2.Either<_i7.ProjectCheckerFailure, bool>>
      checkInRootProject() => (super.noSuchMethod(
            Invocation.method(
              #checkInRootProject,
              [],
            ),
            returnValue:
                _i6.Future<_i2.Either<_i7.ProjectCheckerFailure, bool>>.value(
                    _FakeEither_0<_i7.ProjectCheckerFailure, bool>(
              this,
              Invocation.method(
                #checkInRootProject,
                [],
              ),
            )),
          ) as _i6.Future<_i2.Either<_i7.ProjectCheckerFailure, bool>>);
}

/// A class which mocks [ILogger].
///
/// See the documentation for Mockito's code generation for more information.
class MockILogger extends _i1.Mock implements _i8.ILogger {
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

/// A class which mocks [IFileManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockIFileManager extends _i1.Mock implements _i5.IFileManager {
  MockIFileManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<List<String>> findFilesByExtension(
    String? extension, {
    String? path,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #findFilesByExtension,
          [extension],
          {#path: path},
        ),
        returnValue: _i6.Future<List<String>>.value(<String>[]),
      ) as _i6.Future<List<String>>);
  @override
  _i6.Future<_i2.Either<_i9.FileManagerFailure, Map<dynamic, dynamic>>>
      readYaml(String? path) => (super.noSuchMethod(
            Invocation.method(
              #readYaml,
              [path],
            ),
            returnValue: _i6.Future<
                    _i2.Either<_i9.FileManagerFailure,
                        Map<dynamic, dynamic>>>.value(
                _FakeEither_0<_i9.FileManagerFailure, Map<dynamic, dynamic>>(
              this,
              Invocation.method(
                #readYaml,
                [path],
              ),
            )),
          ) as _i6.Future<
              _i2.Either<_i9.FileManagerFailure, Map<dynamic, dynamic>>>);
  @override
  _i6.Future<
      _i2.Either<_i9.FileManagerFailure, Set<_i4.Directory>>> findPackages(
    _i4.Directory? dir, {
    _i6.Future<bool> Function(_i4.Directory)? where,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #findPackages,
          [dir],
          {#where: where},
        ),
        returnValue: _i6.Future<
                _i2.Either<_i9.FileManagerFailure, Set<_i4.Directory>>>.value(
            _FakeEither_0<_i9.FileManagerFailure, Set<_i4.Directory>>(
          this,
          Invocation.method(
            #findPackages,
            [dir],
            {#where: where},
          ),
        )),
      ) as _i6.Future<_i2.Either<_i9.FileManagerFailure, Set<_i4.Directory>>>);
}

/// A class which mocks [IMagicCommandStrategy].
///
/// See the documentation for Mockito's code generation for more information.
class MockIMagicCommandStrategy extends _i1.Mock
    implements _i10.IMagicCommandStrategy {
  MockIMagicCommandStrategy() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<_i2.Either<_i7.CliFailure, _i4.Process>> runCommand(
          _i4.Directory? dir) =>
      (super.noSuchMethod(
        Invocation.method(
          #runCommand,
          [dir],
        ),
        returnValue: _i6.Future<_i2.Either<_i7.CliFailure, _i4.Process>>.value(
            _FakeEither_0<_i7.CliFailure, _i4.Process>(
          this,
          Invocation.method(
            #runCommand,
            [dir],
          ),
        )),
      ) as _i6.Future<_i2.Either<_i7.CliFailure, _i4.Process>>);
}

/// A class which mocks [Process].
///
/// See the documentation for Mockito's code generation for more information.
class MockProcess extends _i1.Mock implements _i4.Process {
  MockProcess() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<int> get exitCode => (super.noSuchMethod(
        Invocation.getter(#exitCode),
        returnValue: _i6.Future<int>.value(0),
      ) as _i6.Future<int>);
  @override
  _i6.Stream<List<int>> get stdout => (super.noSuchMethod(
        Invocation.getter(#stdout),
        returnValue: _i6.Stream<List<int>>.empty(),
      ) as _i6.Stream<List<int>>);
  @override
  _i6.Stream<List<int>> get stderr => (super.noSuchMethod(
        Invocation.getter(#stderr),
        returnValue: _i6.Stream<List<int>>.empty(),
      ) as _i6.Stream<List<int>>);
  @override
  _i4.IOSink get stdin => (super.noSuchMethod(
        Invocation.getter(#stdin),
        returnValue: _FakeIOSink_2(
          this,
          Invocation.getter(#stdin),
        ),
      ) as _i4.IOSink);
  @override
  int get pid => (super.noSuchMethod(
        Invocation.getter(#pid),
        returnValue: 0,
      ) as int);
  @override
  bool kill([_i4.ProcessSignal? signal = _i4.ProcessSignal.sigterm]) =>
      (super.noSuchMethod(
        Invocation.method(
          #kill,
          [signal],
        ),
        returnValue: false,
      ) as bool);
}

/// A class which mocks [IProcessLogger].
///
/// See the documentation for Mockito's code generation for more information.
class MockIProcessLogger extends _i1.Mock implements _i5.IProcessLogger {
  MockIProcessLogger() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void stdout({
    required int? processId,
    required String? processName,
    required String? stdout,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #stdout,
          [],
          {
            #processId: processId,
            #processName: processName,
            #stdout: stdout,
          },
        ),
        returnValueForMissingStub: null,
      );
  @override
  void stderr({
    required int? processId,
    required String? processName,
    required String? stderr,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #stderr,
          [],
          {
            #processId: processId,
            #processName: processName,
            #stderr: stderr,
          },
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [IDirectoryFactory].
///
/// See the documentation for Mockito's code generation for more information.
class MockIDirectoryFactory extends _i1.Mock implements _i5.IDirectoryFactory {
  MockIDirectoryFactory() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Directory get current => (super.noSuchMethod(
        Invocation.getter(#current),
        returnValue: _FakeDirectory_3(
          this,
          Invocation.getter(#current),
        ),
      ) as _i4.Directory);
}
