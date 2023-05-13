import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
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
    setUpProcessResult(processResult);

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
}
