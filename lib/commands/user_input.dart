import 'package:dartz/dartz.dart';
import 'package:interact/interact.dart';

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

  @override
  Either<None, String> askForPackageName() =>
      right(Input(prompt: 'Package Name').interact());

  @override
  bool askYesOrNo(String question) {
    final options = ['Yes', 'No'];
    final selection = Select(
      prompt: question,
      options: options,
    ).interact();
    return selection == 0;
  }

  @override
  List<String> askSelectPackages({
    required String packagePath,
    required List<AddPackage> packages,
  }) {
    final answers = MultiSelect(
      prompt: 'Select Packages',
      options: packages.map((e) => e.packageName).toList(),
      defaults: packages.map((e) => e.isActive).toList(),
    ).interact();

    final List<String> activePackages = [];

    for (int index in answers) {
      activePackages.add(packages[index].packageName);
    }

    return activePackages;
  }
}
