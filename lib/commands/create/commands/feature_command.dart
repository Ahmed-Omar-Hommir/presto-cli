import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cli/commands/package_manager.dart';
import 'package:cli/commands/user_input.dart';
import 'package:mason/mason.dart';

class CreateFeatureCommand extends Command {
  CreateFeatureCommand({
    required TemplateGenerator locTemp,
    required TemplateGenerator featTemp,
    required TemplateGenerator featBlocTemp,
    required IUserInput userInput,
    required IPackageManager packageManager,
  })  : _locTemp = locTemp,
        _featTemp = featTemp,
        _featBlocTemp = featBlocTemp,
        _userInput = userInput,
        _packageManager = packageManager;

  final TemplateGenerator _locTemp;
  final TemplateGenerator _featTemp;
  final TemplateGenerator _featBlocTemp;
  final IUserInput _userInput;
  final IPackageManager _packageManager;

  @override
  String get name => 'feature';

  @override
  List<String> get aliases => ['feat'];

  @override
  String get description => 'Create New Feature Package';

  @override
  FutureOr? run() async {
    final packageNameOption = _userInput.askForPackageName();

    final String packageName = packageNameOption.fold(
      (_) => exit(0),
      (name) => name,
    );

    final createNewPackageOption =
        await _packageManager.createNewPackage(packageName: packageName);

    if (createNewPackageOption.isLeft()) exit(0);

    final useLocalization = _userInput.askCreateLocalization();

    if (useLocalization) {
      await _locTemp.generate(
        vars: LocalizationTempModel(packageName: packageName),
      );

      await _packageManager.getL10N(packagePath: './$packageName');

      await _packageManager.addDependencies(
        packagePath: './$packageName',
        dependencies: {
          'flutter_localizations': {
            'sdk': 'flutter',
          }
        },
      );
    }

    final result = _userInput.askSelectPackages(
      packagePath: './$packageName',
      packages: [
        AddPackage(packageName: 'bloc', isActive: true),
        AddPackage(packageName: 'flutter_bloc', isActive: true),
        AddPackage(packageName: 'bloc_concurrency', isActive: true),
        AddPackage(packageName: 'flutter_screenutil', isActive: true),
        AddPackage(packageName: 'build_runner'),
        AddPackage(packageName: 'infinite_scroll_pagination'),
        AddPackage(packageName: 'dartz'),
        AddPackage(packageName: 'freezed_annotation'),
        AddPackage(packageName: 'freezed'),
      ],
    );

    await _packageManager.pubAdd(
      packagePath: './$packageName',
      dependencies: result,
    );

    await _featTemp.generate(
      vars: FeatureTempModel(
        packageName: packageName,
        useLocaization: useLocalization,
      ),
    );

    if (result.contains('bloc')) {
      await _featBlocTemp.generate(
        vars: FeatureBlocTempModel(
          packageName: packageName,
        ),
      );
    }
  }
}

abstract class TemplateGenerator<T> {
  Future<void> generate({required T vars});
  Brick get brick;
}

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
  Brick get brick => Brick.path('lib/commands/create/templates/l10n');
}

class LocalizationTempModel {
  const LocalizationTempModel({
    required this.packageName,
  });
  final String packageName;
}

class FeatureTempModel {
  const FeatureTempModel({
    required this.packageName,
    required this.useLocaization,
  });
  final String packageName;
  final bool useLocaization;
}

class FeaturePackageTemp implements TemplateGenerator<FeatureTempModel> {
  @override
  Brick get brick =>
      Brick.path('lib/commands/create/templates/set_up_feature_files');

  @override
  Future<void> generate({required FeatureTempModel vars}) async {
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

class FeatureBlocTempModel {
  const FeatureBlocTempModel({required this.packageName});
  final String packageName;
}

class FeatureBlocTemp implements TemplateGenerator<FeatureBlocTempModel> {
  @override
  Brick get brick => Brick.path('lib/commands/create/templates/bloc_feature');

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
