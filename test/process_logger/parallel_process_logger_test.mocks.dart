// Mocks generated by Mockito 5.4.0 from annotations
// in presto_cli/test/parallel_process_logger/parallel_process_logger_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:mason/mason.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:presto_cli/src/logger.dart' as _i3;

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

class _FakeProgress_0 extends _i1.SmartFake implements _i2.Progress {
  _FakeProgress_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ILogger].
///
/// See the documentation for Mockito's code generation for more information.
class MockILogger extends _i1.Mock implements _i3.ILogger {
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
  _i2.Progress progress(String? message) => (super.noSuchMethod(
        Invocation.method(
          #progress,
          [message],
        ),
        returnValue: _FakeProgress_0(
          this,
          Invocation.method(
            #progress,
            [message],
          ),
        ),
      ) as _i2.Progress);
}
