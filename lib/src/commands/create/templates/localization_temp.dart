import 'dart:io';

import 'package:mason/mason.dart';
import 'package:presto_cli/src/template_generator.dart';
import 'package:presto_cli/presto_cli.dart';

class LocalizationTemp implements TemplateGenerator<LocalizationTempModel> {
  @override
  Future<void> generate({
    required LocalizationTempModel vars,
  }) async {
    final generator = await MasonGenerator.fromBrick(brick);
    final target = DirectoryGeneratorTarget(Directory('./${vars.packageName}'));
    await generator.generate(
      target,
      vars: {
        'name': vars.packageName,
      },
    );

    await _generateL10n(vars.packageName);
  }

  Future<void> _generateL10n(String packageName) async {
    final process = await Process.start(
      'flutter',
      ['gen-l10n'],
      workingDirectory: './$packageName',
    );
    await process.exitCode;
  }

  @override
  Brick get brick => Brick.git(GitPath(
        RemoteRepositoryInfo.url,
        path: 'lib/commands/create/templates/l10n',
      ));
}

class LocalizationTempModel {
  const LocalizationTempModel({
    required this.packageName,
  });
  final String packageName;
}
