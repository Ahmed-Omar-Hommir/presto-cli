import 'dart:async';
import 'dart:math';
import 'package:presto_cli/src/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  late TaskRunner<TaskResultTest> sut;

  setUp(() {
    sut = TaskRunner<TaskResultTest>();
  });

  tearDown(() => sut.dispose());

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
        return TaskResultTest(Duration(seconds: 1));
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

      Future<TaskResultTest> task(Duration durarion) async {
        await Future<void>.delayed(durarion);
        return TaskResultTest(Duration(seconds: 1));
      }

      final List<Future<TaskResultTest> Function()> tasks = [
        () => task(Duration(seconds: 1)),
        () => task(Duration(seconds: 1)),
        () => task(Duration(milliseconds: 500)),
        () => task(Duration(milliseconds: 500)),
      ];

      // Act
      final startTime = DateTime.now();
      final result = await sut.run(tasks: tasks, concurrency: 3);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      // Assert
      expect(duration.inSeconds, lessThan(1.1));
      expect(result.length, 4);
    },
  );
  test(
    'should run tasks when concurrency large than number of tasks.',
    () async {
      // Arrange

      Future<TaskResultTest> task(Duration durarion) async {
        await Future<void>.delayed(durarion);
        return TaskResultTest(Duration(seconds: 1));
      }

      final List<Future<TaskResultTest> Function()> tasks = [
        () => task(Duration(seconds: 1)),
        () => task(Duration(seconds: 1)),
        () => task(Duration(milliseconds: 500)),
        () => task(Duration(milliseconds: 500)),
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
      expect(duration.inSeconds, lessThan(1.1));
      expect(result.length, 4);
    },
  );

  test(
    'should wait result function after task complete.',
    () async {
      // Arrange
      Future<TaskResultTest> task() async {
        return TaskResultTest(Duration(seconds: 1));
      }

      final List<Future<TaskResultTest> Function()> tasks = [
        () => task(),
        () => task(),
        () => task(),
        () => task(),
        () => task(),
        () => task(),
      ];

      // Act
      final startTime = DateTime.now();
      final result = await sut.run(
          tasks: tasks,
          concurrency: 3,
          resultWaiter: (result) async {
            await result.exitCode();
          });
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      // Assert
      expect(duration.inSeconds, lessThan(2.1));
      expect(duration.inSeconds, greaterThan(1.9));
      expect(result.length, equals(6));
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
