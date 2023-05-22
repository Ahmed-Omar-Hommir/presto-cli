import 'package:mason/mason.dart';
import 'package:mason_logger/mason_logger.dart' as mason_logger;

abstract class ILogger {
  void error(String message);
  void info(String message);
  void warn(String message);
  void write(String message);
  Progress progress(String message);
}

class Logger implements ILogger {
  late final _masonLogger = mason_logger.Logger();

  @override
  void error(String message) {
    _masonLogger.err(message);
  }

  @override
  void info(String message) {
    _masonLogger.info(message);
  }

  @override
  void warn(String message) {
    _masonLogger.warn(message);
  }

  @override
  void write(String message) {
    _masonLogger.write(message);
  }

  @override
  Progress progress(String message) {
    return _masonLogger.progress(message);
  }
}
