import 'package:presto_cli/src/utils/task_distribution_manager.dart';
import 'package:test/test.dart';

void main() {
  var taskManager = TaskDistributionManager<int>();

  test('Test with equal number of tasks and isolates', () {
    // Arrange
    var tasks = [1, 2, 3, 4];
    var isolates = 4;

    // Act
    var result = taskManager.distributeTasks(
      numberOfIsolates: isolates,
      tasks: tasks,
    );

    // Asset
    expect(
        result,
        equals([
          [1],
          [2],
          [3],
          [4]
        ]));
  });

  test('Test with more tasks than isolates', () {
    // Arrange
    var tasks = [1, 2, 3, 4, 5, 6];
    var isolates = 3;

    // Act
    var result = taskManager.distributeTasks(
      numberOfIsolates: isolates,
      tasks: tasks,
    );

    // Asset
    expect(
      result,
      equals([
        [1, 4],
        [2, 5],
        [3, 6]
      ]),
    );
  });

  test('Test with more isolates than tasks', () {
    // Arrange
    var tasks = [1, 2, 3];
    var isolates = 5;

    // Act
    var result = taskManager.distributeTasks(
      numberOfIsolates: isolates,
      tasks: tasks,
    );

    // Asset
    expect(
        result,
        equals([
          [1],
          [2],
          [3]
        ]));
  });

  test('Test with one isolate', () {
    // Arrange
    var tasks = [1, 2, 3, 4, 5, 6];
    var isolates = 1;

    // Act
    var result = taskManager.distributeTasks(
      numberOfIsolates: isolates,
      tasks: tasks,
    );

    // Asset
    expect(result, equals([tasks]));
  });

  test('Test with empty tasks', () {
    // Arrange
    var tasks = <int>[];
    var isolates = 3;

    // Act
    var result = taskManager.distributeTasks(
      numberOfIsolates: isolates,
      tasks: tasks,
    );

    // Asset
    expect(result, equals([]));
  });
}
