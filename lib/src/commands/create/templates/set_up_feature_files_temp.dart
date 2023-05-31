import 'dart:io';

import 'package:mason/mason.dart';
import 'package:presto_cli/src/template_generator.dart';
import 'package:presto_cli/presto_cli.dart';

class SetUpFeatureFilesTemp
    implements TemplateGenerator<SetUpFeatureFilesTempModel> {
  @override
  Brick get brick => Brick.git(GitPath(
        RemoteRepositoryInfo.url,
        path: 'lib/commands/create/templates/set_up_feature_files',
      ));

  @override
  Future<void> generate({required SetUpFeatureFilesTempModel vars}) async {
    final generator = await MasonGenerator.fromBrick(brick);
    final target = DirectoryGeneratorTarget(Directory('./${vars.packageName}'));
    await generator.generate(
      target,
      vars: <String, dynamic>{
        'name': vars.packageName,
        'useLocalization': vars.useLocaization,
      },
    );
  }
}

class SetUpFeatureFilesTempModel {
  const SetUpFeatureFilesTempModel({
    required this.packageName,
    required this.useLocaization,
  });
  final String packageName;
  final bool useLocaization;
}
