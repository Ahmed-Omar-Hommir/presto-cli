import 'dart:io';

import 'package:mason/mason.dart';
import 'package:presto_cli/src/template_generator.dart';
import 'package:presto_cli/presto_cli.dart';

class FeatureBlocTemp implements TemplateGenerator<FeatureBlocTempModel> {
  @override
  Brick get brick => Brick.git(GitPath(
        RemoteRepositoryInfo.url,
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
