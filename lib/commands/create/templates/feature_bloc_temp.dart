import 'dart:io';

import 'package:presto_cli/commands/template_generator.dart';
import 'package:mason/mason.dart';

class FeatureBlocTemp implements TemplateGenerator<FeatureBlocTempModel> {
  @override
  Brick get brick => Brick.git(GitPath(
        'https://gitlab.com/Ahmed-Omar-Prestoeat/presto_cli',
        path: 'lib/commands/create/templates/bloc_feature',
      ));

  @override
  Future<void> generate({required FeatureBlocTempModel vars}) async {
    final generator = await MasonGenerator.fromBrick(brick);
    final target = DirectoryGeneratorTarget(Directory('./${vars.packageName}'));
    await generator.generate(
      target,
      vars: <String, dynamic>{'name': vars.packageName},
    );
  }
}

class FeatureBlocTempModel {
  const FeatureBlocTempModel({required this.packageName});
  final String packageName;
}
