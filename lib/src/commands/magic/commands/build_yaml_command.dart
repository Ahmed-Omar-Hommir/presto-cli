import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:presto_cli/src/build_yaml/build_yaml_generator.dart';
import 'package:presto_cli/src/logger.dart';

class BuildYamlCommand extends Command<int> {
  BuildYamlCommand({
    required IBuildYamlGenerator buildYamlGenerator,
    required ILogger logger,
  })  : _buildYamlGenerator = buildYamlGenerator,
        _logger = logger;
  final IBuildYamlGenerator _buildYamlGenerator;
  final ILogger _logger;

  @override
  String get name => 'build_yaml';

  @override
  String get description => 'Generate build.yaml file.';

  @override
  Future<int> run() async {
    _logger.error(
      'Progress...',
    );

    try {
      final result = await _buildYamlGenerator.genBuildYaml(packagePath: '.');
      _logger.error(
        'Done.',
      );
      result.fold(
        (failure) {
          failure.map(
            pubspecFileIsNotExist: (_) => _logger.error(
              'pubspec.yaml file is not exist in the current directory.',
            ),
            buildRunnerIsNotExist: (_) => _logger
                .error('build_runner is not exist in the current directory.'),
            unknown: (_) => _logger.error('Unknown error.'),
          );
        },
        (_) => _logger.info('build.yaml file is generated successfully.'),
      );
    } catch (e) {
      print(e);
    }
    return 0;
  }
}
