import 'dart:async';
import 'dart:math';
import 'package:presto_cli/src/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  late TaskRunner<TaskResultTest> sut;

  setUp(() {
    sut = TaskRunner<TaskResultTest>();
  });

  test(
    'should runs tasks concurrently up to the concurrency limit.',
    () async {
      // Arrange
      int runningTasks = 0;
      int maxConcurrency = 0;

      Future<TaskResultTest> task(int index) async {
        runningTasks++;
        maxConcurrency = max(maxConcurrency, runningTasks);
        await Future<void>.delayed(Duration(microseconds: 200));
        runningTasks--;
        return TaskResultTest(Duration(microseconds: 1));
      }

      final tasks = List<Future<TaskResultTest> Function()>.generate(
          25, (index) => () => task(index));

      // Act
      final result = await sut.run(tasks: tasks, concurrency: 3);

      // Assert
      expect(maxConcurrency, 3);
      expect(result.length, 25);
    },
  );
  test(
    'should run next task immediately after one of the running tasks completes.',
    () async {
      // Arrange
      Future<TaskResultTest> task(Duration duration) async {
        await Future<void>.delayed(duration);
        return TaskResultTest(Duration(milliseconds: 1));
      }

      final List<Future<TaskResultTest> Function()> tasks = [
        () => task(Duration(milliseconds: 200)),
        () => task(Duration(milliseconds: 200)),
        () => task(Duration(milliseconds: 100)),
        () => task(Duration(milliseconds: 100)),
      ];

      // Act
      final startTime = DateTime.now();
      final result = await sut.run(tasks: tasks, concurrency: 3);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      // Assert
      expect(duration.inMilliseconds, lessThan(300));
      expect(result.length, 4);
    },
  );
  test(
    'test',
    () async {
      // Arrange
      Future<TaskResultTest> task(Duration duration) async {
        await Future<void>.delayed(duration);
        return TaskResultTest(Duration(seconds: 1));
      }

      final List<Future<TaskResultTest> Function()> tasks = [
        () => task(Duration(milliseconds: 200)),
        () => task(Duration(milliseconds: 200)),
        () => task(Duration(milliseconds: 200)),
        () => task(Duration(milliseconds: 200)),
      ];

      // Act
      final startTime = DateTime.now();
      final result = await sut.run(
        tasks: tasks,
        concurrency: 3,
        resultWaiter: (value) => value.exitCode(),
      );
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      // Assert
      // expect(duration.inMilliseconds, lessThan(300));
      // expect(result.length, 4);
    },
  );

  test(
    'should run tasks when concurrency large than number of tasks.',
    () async {
      // Arrange

      Future<TaskResultTest> task(Duration durarion) async {
        await Future<void>.delayed(durarion);
        return TaskResultTest(Duration(milliseconds: 1));
      }

      final List<Future<TaskResultTest> Function()> tasks = [
        () => task(Duration(milliseconds: 200)),
        () => task(Duration(milliseconds: 200)),
        () => task(Duration(milliseconds: 100)),
        () => task(Duration(milliseconds: 100)),
      ];

      // Act
      final startTime = DateTime.now();
      final result = await sut.run(
        tasks: tasks,
        concurrency: tasks.length * tasks.length,
      );
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      // Assert
      expect(duration.inMilliseconds, lessThan(300));
      expect(result.length, 4);
    },
  );

  test(
    'should wait result function after task complete.',
    () async {
      // Arrange
      final milliseconds = 200;
      Future<TaskResultTest> task() async {
        return TaskResultTest(Duration(milliseconds: milliseconds));
      }

      final List<Future<TaskResultTest> Function()> tasks = [
        () => task(),
        () => task(),
        () => task(),
        () => task(),
        () => task(),
        () => task(),
      ];

      final concurrency = 3;
      final total = (tasks.length * milliseconds) / concurrency;

      // Act
      final startTime = DateTime.now();
      final result = await sut.run(
        tasks: tasks,
        concurrency: concurrency,
        resultWaiter: (result) => result.exitCode(),
      );
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      // Assert
      expect(duration.inMilliseconds, lessThan(total + 100));
      expect(duration.inMilliseconds, greaterThan(total - 100));
      expect(result.length, equals(6));
    },
  );

  test(
    'should the second concurrency be ignored when all tasks are executed once in the first concurrency.',
    () async {
      // Arrange
      int runningTasks = 0;
      int maxConcurrency = 0;

      Future<TaskResultTest> task(int index) async {
        runningTasks++;
        maxConcurrency = max(maxConcurrency, runningTasks);
        await Future<void>.delayed(Duration.zero);
        runningTasks--;
        return TaskResultTest(Duration(milliseconds: 1));
      }

      final tasks = List<Future<TaskResultTest> Function()>.generate(
        25,
        (index) => () => task(index),
      );

      // Act
      await sut.run(tasks: tasks, concurrency: 2);
    },
  );
}

class TaskResultTest {
  const TaskResultTest(this.duration);
  final Duration duration;
  Future<int> exitCode() async {
    await Future.delayed(duration);
    return 0;
  }
}
