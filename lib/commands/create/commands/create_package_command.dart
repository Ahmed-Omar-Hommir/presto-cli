import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cli/commands/package_manager.dart';
import 'package:dart_console/dart_console.dart';
import 'package:file/local.dart';

class CreatePackageCommand extends Command {
  CreatePackageCommand({
    required IPackageManager packageManager,
  }) : _packageManager = packageManager;

  final IPackageManager _packageManager;

  @override
  String get name => 'package';

  @override
  String get description => 'Create New Package';

  @override
  FutureOr? run() async {
//     final console = Console();

//     // Ask for Package Name
//     final value = _packageManager.askForPackageName();

//     final packageName = value.fold(
//       (_) {
//         // Todo: Handle Exception.
//         exit(0);
//       },
//       (packageName) => packageName,
//     );

//     final packagePath = "./$packageName";

//     // Ask for package type
//     final packageTypeOption = _packageManager.askForPackageType();

//     packageTypeOption.maybeMap(
//       repository: (value) {
//         console.writeLine('Repository Package Is Coming Soon...');
//         exit(0);
//       },
//       service: (value) {
//         console.writeLine('Service Package Is Coming Soon...');
//         exit(0);
//       },
//       orElse: () {},
//     );

//     // Create New Package using Package Name
//     final response = await _packageManager.createNewPackage(
//       packageName: packageName,
//     );

//     response.fold(
//       // ignore: void_checks
//       (l) {
//         console.writeLine('$packageName Package Is Created Successfuly.');
//         exit(0);
//       },
//       (r) => console.writeLine('$packageName Package Is Created Successfuly.'),
//     );

//     // Ask Depend on Package Type
//     await packageTypeOption.map(
//       feature: (value) async {
//         // L10N
//         if (await _packageManager.askCreateLocalization()) {
//           await _packageManager.createLocalization(
//             packagePath: packagePath,
//             packageName: packageName,
//           );
//         }

//         // Dependencies
//         final packagesAdded = await _packageManager.addPackages(
//           packagePath: packagePath,
//           packages: [
    // AddPackage(packageName: 'bloc', isActive: true),
    // AddPackage(packageName: 'flutter_bloc', isActive: true),
    // AddPackage(packageName: 'bloc_concurrency', isActive: true),
    // AddPackage(packageName: 'flutter_screenutil', isActive: true),
    // AddPackage(packageName: 'build_runner'),
    // AddPackage(packageName: 'infinite_scroll_pagination'),
    // AddPackage(packageName: 'dartz'),
    // AddPackage(packageName: 'freezed_annotation'),
    // AddPackage(packageName: 'freezed'),
//           ],
//         );

//         // Make Common Files

//         final fs = const LocalFileSystem();
//         final srcPath = '$packageName/lib/src';
//         final libPath = '$packageName/lib';
//         final l10nDirectory = fs.directory(srcPath);
//         l10nDirectory.createSync(recursive: true);

//         // make page file

//         final pageFile = fs.file('$srcPath/${packageName}_page.dart');
//         final pageFileContent = """
// import 'package:flutter/material.dart';

// class ${convertToCamelCase(packageName)}Page extends StatefulWidget {
//   const ${convertToCamelCase(packageName)}Page({super.key});

//   @override
//   State<${convertToCamelCase(packageName)}Page> createState() => _${convertToCamelCase(packageName)}PageState();
// }

// class _${convertToCamelCase(packageName)}PageState extends State<${convertToCamelCase(packageName)}Page> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
//         """;
//         pageFile.writeAsStringSync(pageFileContent);

//         final composerFile = fs.file('$srcPath/${packageName}_composer.dart');

//         final composerFileContent = """
// import 'package:flutter/material.dart';

// import '${packageName}_page.dart';

// abstract class ${convertToCamelCase(packageName)}Composer {
//   static Widget compose${convertToCamelCase(packageName)}Page() {
//     return ${convertToCamelCase(packageName)}Page();
//   }
// }
//         """;

//         composerFile.writeAsStringSync(composerFileContent);

//         // make logic file if (bloc or flutter bloc is add in dependecies)
//         // make export file

//         final exportFile = fs.file('$libPath/$packageName.dart');
//         final exportFileContent = """
// library $packageName;

// export './src/${packageName}_composer.dart';
//         """;

//         exportFile.writeAsStringSync(exportFileContent);
//       },
//       repository: (value) {
//         console.writeLine('Repository Package Is Coming Soon...');
//         exit(0);
//       },
//       service: (value) {
//         console.writeLine('Service Package Is Coming Soon...');
//         exit(0);
//       },
//     );

//     console.writeLine('$packageName Package Is Ready.');
  }
}
