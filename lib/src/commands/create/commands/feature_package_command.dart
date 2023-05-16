import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dartz/dartz.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:presto_cli/src/commands/create/templates/feature_bloc_temp.dart';
import 'package:presto_cli/src/commands/create/templates/set_up_feature_files_temp.dart';
import 'package:presto_cli/src/package_manager.dart';
import 'package:presto_cli/src/template_generator.dart';
import 'package:presto_cli/src/user_input.dart';

import '../templates/localization_temp.dart';

class CreateFeaturePackageCommand extends Command<int> {
  CreateFeaturePackageCommand({
    required TemplateGenerator locTemp,
    required TemplateGenerator featTemp,
    required TemplateGenerator featBlocTemp,
    required IUserInput userInput,
    required IPackageManager packageManager,
    required IFlutterCLI flutterCli,
    required Logger logger,
  })  : _locTemp = locTemp,
        _featTemp = featTemp,
        _featBlocTemp = featBlocTemp,
        _userInput = userInput,
        _logger = logger,
        _packageManager = packageManager,
        _flutterCli = flutterCli;

  final TemplateGenerator _locTemp;
  final TemplateGenerator _featTemp;
  final TemplateGenerator _featBlocTemp;
  final IUserInput _userInput;
  final IPackageManager _packageManager;
  final Logger _logger;
  final IFlutterCLI _flutterCli;

  @override
  String get name => 'feature';

  @override
  List<String> get aliases => ['feat'];

  @override
  String get description => 'Create New Feature Package';

  @override
  Future<int> run() async {
    final packageNameOption = _userInput.askForPackageName();

    final String packageName = packageNameOption.fold(
      (_) => exit(0),
      (name) => name,
    );

    final createPackageProgress =
        _logger.progress('Creating $packageName package for you');

    final createNewPackageResult = await _flutterCli.createNewPackage(
      packageName: packageName,
    );

    createNewPackageResult.fold(
      (failure) {
        _logger.err("Couldn't create package $packageName");
        createPackageProgress.cancel;
      },
      (response) => createPackageProgress.complete('Package created!'),
    );

    if (createNewPackageResult is Left) {
      exit(1);
    }

    final useLocalization = _userInput.askCreateLocalization();

    if (useLocalization) {
      final locProgress = _logger.progress('Creating L10N files');
      await _locTemp.generate(
        vars: LocalizationTempModel(packageName: packageName),
      );
      locProgress.update('add flutter localization');
      await _packageManager.addDependencies(
        packagePath: './$packageName',
        dependencies: {
          'flutter_localizations': {
            'sdk': 'flutter',
          }
        },
      );

      locProgress.update('generating localization');
      await _flutterCli.genL10N(packagePath: './$packageName');
      locProgress
          .complete(lightCyan.wrap(styleBold.wrap('Localization Done!')));
    }

    final result = _userInput.askSelectPackages(
      packagePath: './$packageName',
      packages: [
        AddPackage(packageName: 'bloc', isActive: true),
        AddPackage(packageName: 'flutter_bloc', isActive: true),
        AddPackage(packageName: 'bloc_concurrency', isActive: true),
        AddPackage(packageName: 'flutter_screenutil', isActive: true),
        AddPackage(packageName: 'flutter_phosphor_icons'),
        AddPackage(packageName: 'build_runner'),
        AddPackage(packageName: 'infinite_scroll_pagination'),
        AddPackage(packageName: 'dartz'),
        AddPackage(packageName: 'freezed_annotation'),
        AddPackage(packageName: 'freezed'),
      ],
    );

    final packagePath = File(packageName);

    final x = await _flutterCli.pubAdd(
      packagePath: packagePath.path,
      dependencies: result
          .map((name) => PackageDependency(
                name: name,
                version: null,
              ))
          .toSet(),
    );

    await x.fold(
      (failure) {
        failure.maybeMap(
          pubspecFileNotFound: (_) {
            _logger.err('pubspec.yaml file not found');
          },
          emptyDependencies: (_) {
            _logger.err('dependencies is empty');
          },
          unknown: (value) {
            _logger.err('unknown error\n${value.e}');
          },
          orElse: () => null,
        );
      },
      (response) async {
        _logger.detail(response.output);
        await response.exitCodeStatus.map(
          success: (value) async {
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
          },
          failure: (value) {},
        );
      },
    );
    return 0;
  }
}
