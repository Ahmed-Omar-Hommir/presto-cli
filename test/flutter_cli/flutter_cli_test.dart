import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:test/test.dart';
import 'flutter_cli_test.mocks.dart';
import 'helper.dart';

@GenerateMocks([IProcessManager, Process, ProcessResult])
void main() {
  late IProcessManager processManager;
  late IFlutterCLI sut;
  late MockProcessResult processResult;

  setUp(() {
    processResult = MockProcessResult();
    whenProcessResult(processResult);

    processManager = MockIProcessManager();

    sut = FlutterCLI(processManager: processManager);
  });

  group('Pub Add', () {
    group(
      'Success cases',
      () {
        test(
          'should add package successfully and call processManager.run with correct values when has one dependency.',
          () async {
            // Arrange
            final tempDir = Directory.systemTemp.createTempSync();
            final packagePath = tempDir.path;

            await createPubspecFile(packagePath);

            whenRunPubAdd(
              processManager: processManager,
              answer: processResult,
              dependencies: [DependencyA.dependency],
            );

            // Act
            final result = await sut.pubAdd(
              packagePath: packagePath,
              dependencies: {
                PackageDependency(
                  name: DependencyA.name,
                  version: DependencyA.version,
                ),
              },
            );

            // Assert
            expect(result, isA<Right>());
            expect(
              result.getOrElse(() => fail('Result returned a Left')),
              isA<ProcessResponse>(),
            );

            verifyPubAdd(
              processManager: processManager,
              dependencies: [DependencyA.dependency],
              packagePath: packagePath,
            ).called(1);
            verifyNoMoreInteractions(processManager);
          },
        );

        test(
          'should add package successfully and call processManager.run with correct values when has more than one dependency.',
          () async {
            // Arrange
            final tempDir = Directory.systemTemp.createTempSync();
            final packagePath = tempDir.path;

            await createPubspecFile(packagePath);

            whenRunPubAdd(
              processManager: processManager,
              answer: processResult,
              dependencies: [
                DependencyA.dependency,
                DependencyB.dependency,
                DependencyC.dependency,
              ],
            );

            // Act
            final result = await sut.pubAdd(
              packagePath: packagePath,
              dependencies: {
                PackageDependency(
                  name: DependencyA.name,
                  version: DependencyA.version,
                ),
                PackageDependency(
                  name: DependencyB.name,
                  version: DependencyB.version,
                ),
                PackageDependency(
                  name: DependencyC.name,
                  version: DependencyC.version,
                ),
              },
            );

            // Assert
            expect(result, isA<Right>());
            expect(
              result.getOrElse(() => fail('Result returned a Left')),
              isA<ProcessResponse>(),
            );

            verifyPubAdd(
              processManager: processManager,
              dependencies: [
                DependencyA.dependency,
                DependencyB.dependency,
                DependencyC.dependency,
              ],
              packagePath: packagePath,
            ).called(1);
            verifyNoMoreInteractions(processManager);
          },
        );
      },
    );

    group('Failure cases', () {
      test(
        'should return a Left<$CliFailureUnknown> when processManager.run throws an exception.',
        () async {
          // Arrange
          final tempDir = Directory.systemTemp.createTempSync();
          final packagePath = tempDir.path;

          await createPubspecFile(packagePath);

          when(processManager.run(
            'flutter',
            ['pub', 'add', DependencyA.dependency],
            workingDirectory: packagePath,
          )).thenThrow(Exception());

          // Act
          final result = await sut.pubAdd(
            packagePath: packagePath,
            dependencies: {
              PackageDependency(
                name: DependencyA.name,
                version: DependencyA.version,
              ),
            },
          );

          // Assert
          expect(result, isA<Left>());
          expect(
            result.fold(
              (failure) => failure,
              (_) => fail('Result returned a Right'),
            ),
            isA<CliFailureUnknown>(),
          );

          verifyPubAdd(
            processManager: processManager,
            dependencies: [DependencyA.dependency],
            packagePath: packagePath,
          ).called(1);
          verifyNoMoreInteractions(processManager);
        },
      );

      test(
        'should return a Left<$CliFailurePubspecFileNotFound> when pubspec.yaml file not found.',
        () async {
          // Arrange
          final tempDir = Directory.systemTemp.createTempSync();
          final packagePath = tempDir.path;

          // Act
          final result = await sut.pubAdd(
            packagePath: packagePath,
            dependencies: {
              PackageDependency(
                name: DependencyA.name,
                version: DependencyA.version,
              ),
            },
          );

          // Assert
          expect(result, isA<Left>());
          expect(
            result.fold(
              (failure) => failure,
              (_) => fail('Result returned a Right'),
            ),
            isA<CliFailurePubspecFileNotFound>(),
          );

          verifyZeroInteractions(processManager);
        },
      );

      test(
        'should return a Left<$CliFailureEmptyDependencies> when dependencies is empty.',
        () async {
          // Arrange
          final tempDir = Directory.systemTemp.createTempSync();
          final packagePath = tempDir.path;

          // Act
          final result = await sut.pubAdd(
            packagePath: packagePath,
            dependencies: {},
          );

          // Assert
          expect(result, isA<Left>());
          expect(
            result.fold(
              (failure) => failure,
              (_) => fail('Result returned a Right'),
            ),
            isA<CliFailureEmptyDependencies>(),
          );

          verifyZeroInteractions(processManager);
        },
      );
    });
  });

  group(
    'Create New Package',
    () {
      group('Success cases', () {
        test(
          'should create new package successfully and call processManager.run with correct values.',
          () async {
            // Arrange
            final tempDir = Directory.systemTemp.createTempSync();
            final packagePath = tempDir.path;

            const packageName = 'test_package';

            whenCreateNewPackage(
              packageName: packageName,
              processManager: processManager,
            ).thenAnswer((_) async => processResult);

            // Act
            final result = await sut.createNewPackage(
              packageName: packageName,
              packagePath: packagePath,
            );

            // Assert

            verifyCreateNewPackage(
              packageName: packageName,
              packagePath: packagePath,
              processManager: processManager,
            ).called(1);

            verifyNoMoreInteractions(processManager);

            expect(result, isA<Right>());
            expect(
              result.getOrElse(() => fail('Result returned a Left')),
              isA<ProcessResponse>(),
            );
          },
        );
      });

      group(
        'Failure cases',
        () {
          test(
            'should return Left<$CliFailureInvalidPackageName> when package name is invalid and call processManager.run with correct values.',
            () async {
              // Arrange
              final tempDir = Directory.systemTemp.createTempSync();
              final packagePath = tempDir.path;

              const packageName = 'INVALID_PACKAGE_NAME';

              whenCreateNewPackage(
                packageName: packageName,
                processManager: processManager,
              ).thenAnswer((_) async => processResult);

              // Act
              final result = await sut.createNewPackage(
                packageName: packageName,
                packagePath: packagePath,
              );

              // Assert
              verifyZeroInteractions(processManager);
              expect(result, isA<Left>());
              expect(
                result.fold(
                  (failure) => failure,
                  (_) => fail('Result returned a Right'),
                ),
                isA<CliFailureInvalidPackageName>(),
              );
            },
          );

          test(
            'should return a Left<$CliFailureUnknown> when processManager.run throws an exception.',
            () async {
              // Arrange
              final tempDir = Directory.systemTemp.createTempSync();
              final packagePath = tempDir.path;

              const packageName = 'test_package';

              whenCreateNewPackage(
                processManager: processManager,
                packageName: packageName,
              ).thenThrow(Exception());

              // Act
              final result = await sut.createNewPackage(
                packageName: packageName,
                packagePath: packagePath,
              );

              // Assert
              expect(result, isA<Left>());
              expect(
                result.fold(
                  (failure) => failure,
                  (_) => fail('Result returned a Right'),
                ),
                isA<CliFailureUnknown>(),
              );

              verifyCreateNewPackage(
                packageName: packageName,
                packagePath: packagePath,
                processManager: processManager,
              ).called(1);
              verifyNoMoreInteractions(processManager);
            },
          );

          test(
            'should return a Left<$CliFailurePackageAlreadyExists> when package already exists.',
            () async {
              // Arrange
              const packageName = 'test_package';

              final tempDir = Directory.systemTemp.createTempSync();

              final newDir = Directory(join(tempDir.path, packageName));
              newDir.createSync();

              final packagePath = tempDir.path;

              whenCreateNewPackage(
                processManager: processManager,
                packageName: packageName,
              ).thenAnswer((_) async => processResult);

              // Act
              final result = await sut.createNewPackage(
                packageName: packageName,
                packagePath: packagePath,
              );

              // Assert
              expect(result, isA<Left>());
              expect(
                result.fold(
                  (failure) => failure,
                  (_) => fail('Result returned a Right'),
                ),
                isA<CliFailurePackageAlreadyExists>(),
              );

              verifyZeroInteractions(processManager);
            },
          );
        },
      );
    },
  );
}
