import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:presto_cli/commands/create/templates/feature_bloc_temp.dart';
import 'package:presto_cli/commands/create/templates/localization_temp.dart';
import 'package:presto_cli/commands/create/templates/set_up_feature_files_temp.dart';
import 'package:presto_cli/commands/package_manager.dart';
import 'package:presto_cli/commands/template_generator.dart';
import 'package:presto_cli/commands/user_input.dart';

class CreateFeaturePackageCommand extends Command {
  CreateFeaturePackageCommand({
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
      vars: SetUpFeatureFilesTempModel(
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
