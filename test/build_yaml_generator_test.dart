// Todo: Refactor with Write test for build_yaml_generator.dart

import 'package:test/test.dart';

void main() {
  test('Todo: Refactor with Write test for build_yaml_generator.dart',
      () => null);
}

// import 'dart:io';
// import 'package:dartz/dartz.dart';
// import 'package:presto_cli/src/build_yaml/build_yaml_generator.dart';
// import 'package:presto_cli/src/package_manager.dart';
// import 'package:test/test.dart';
// import 'package:archive/archive_io.dart';

// void main() {
//   late IBuildYamlGenerator buildYamlGenerator;
//   final Directory tempDir = Directory('test/temp');

//   setUp(() {
//     buildYamlGenerator = BuildYamlGenerator(packageManager: PackageManager());
//   });

//   tearDown(() async {
//     await tempDir.delete(recursive: true);
//   });

//   void readCase(String caseName) {
//     final bytes = File('test/$caseName.zip').readAsBytesSync();
//     final archive = ZipDecoder().decodeBytes(bytes);
//     extractArchiveToDisk(archive, tempDir.path);
//   }

//   group('Build Yaml Success', () {
//     test(
//       'should generate build.yaml file when pubspec.yaml is exist and return right()',
//       () async {
//         // arrange
//         readCase('success_case');

//         // Act
//         final result = await buildYamlGenerator.genBuildYaml(
//           relativePath: tempDir.path,
//         );

//         // Assert
//         // expect(result, isA<Right>());
//       },
//     );

//     // test when build.yaml is exist should be replace it.
//     // test when no files to generate should return right('empty')
//     // test build.yaml file content
//   });

//   group('Build Yaml Failure', () {
//     test(
//       'should return failure when pubspec.yaml is not exist.',
//       () async {
//         // arrange
//         readCase('pubspec_not_exist');

//         // Act
//         final result = await buildYamlGenerator.genBuildYaml(
//           relativePath: tempDir.path,
//         );

//         // Assert

//         // Check if the result is a Left value of GenBuildYamlFailure
//         expect(
//           result,
//           isA<Either<BuildYamlFailure, String>>()
//               .having((e) => e.isLeft(), 'isLeft', true),
//         );

//         // Check if the result contains the correct failure type
//         result.fold(
//           (failure) =>
//               expect(failure, isA<BuildYamlFailurePubspecFileIsNotExist>()),
//           (_) => fail('Expected a Left value containing a GenBuildYamlFailure'),
//         );
//       },
//     );
//     test(
//       'should return left when pubspec.yaml is not contain build_runner packages.',
//       () async {
//         // Arrange
//         readCase('without_build_runner');

//         // Act
//         final result = await buildYamlGenerator.genBuildYaml(
//           relativePath: tempDir.path,
//         );

//         // Assert

//         // Check if the result is a Left value of GenBuildYamlFailure
//         expect(
//           result,
//           isA<Either<BuildYamlFailure, String>>()
//               .having((e) => e.isLeft(), 'isLeft', true),
//         );

//         // Check if the result contains the correct failure type
//         result.fold(
//           (failure) =>
//               expect(failure, isA<BuildYamlFailureBuildRunnerIsNotExist>()),
//           (_) => fail('Expected a Left value containing a GenBuildYamlFailure'),
//         );
//       },
//     );
//   });
// }
