import 'package:cli/utils/model/arguments.dart';

abstract class HandleArguments {
  static Arguments getArgumentType(List<String> arguments) {
    final argument = arguments.first;
    if (argument == 'help') return Arguments.help();
    if (argument == 'packages') return Arguments.packages();
    return Arguments.unknown(argument);
  }
}
