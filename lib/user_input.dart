import 'package:dartz/dartz.dart';
import 'package:mason/mason.dart';

import 'package_manager.dart';

abstract class IUserInput {
  bool askYesOrNo(String question);
  Either<None, String> askForPackageName();
  bool askCreateLocalization();
  List<String> askForDependencies();
  List<String> askSelectPackages({
    required String packagePath,
    required List<AddPackage> packages,
  });
}

class UserInput implements IUserInput {
  @override
  bool askCreateLocalization() => askYesOrNo('You need localization?');

  @override
  List<String> askForDependencies() {
    throw UnimplementedError();
  }

  final Logger logger = Logger();

  @override
  Either<None, String> askForPackageName() {
    return right(logger.prompt('Package Name:'));
  }

  @override
  bool askYesOrNo(String question) {
    final option = logger.chooseOne(
      question,
      choices: ['yes', 'no'],
    );

    return option == 'yes';
  }

  @override
  List<String> askSelectPackages({
    required String packagePath,
    required List<AddPackage> packages,
  }) {
    return logger.chooseAny<String>(
      'Select Packages',
      choices: packages.map((e) => e.packageName).toList(),
      defaultValues: packages
          .where((value) => value.isActive)
          .toList()
          .map((e) => e.packageName)
          .toList(),
    );
  }
}
