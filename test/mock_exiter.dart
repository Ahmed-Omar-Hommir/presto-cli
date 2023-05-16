import 'package:presto_cli/presto_cli.dart';

class MockExiter implements Exiter {
  int? exitCode;

  @override
  Never exit(int code) {
    exitCode = code;
    throw 'Exit with code $code';
  }
}
