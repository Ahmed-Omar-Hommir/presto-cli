import 'package:presto_cli/src/utils/utils.dart';
import 'package:test/test.dart';
import 'package:presto_cli/src/version.dart';

void main() {
  late FileManager fileManager;
  setUp(() {
    fileManager = FileManager();
  });

  test(
    'should ensure that packageVersion in pubspec.yaml matches generated packageVersion.',
    () async {
      // Arrange
      final result = await fileManager.readYaml('pubspec.yaml');

      // Act
      final generatedVersion = packageVersion;

      // Assert
      expect(
        result.fold(
          (failure) => fail(failure.toString()),
          (content) => content['version'],
        ),
        generatedVersion,
      );
    },
  );
}
