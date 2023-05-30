import 'dart:math';

import 'package:async/async.dart';

abstract class ITasksRunner<T> {
  Future<List<T>> run({
    required List<Future<T> Function()> tasks,
    required int concurrency,
    Future Function(T)? resultWaiter,
  });
}

class TaskRunner<T> implements ITasksRunner<T> {
  @override
  Future<List<T>> run({
    required List<Future<T> Function()> tasks,
    required int concurrency,
    Future Function(T)? resultWaiter,
  }) async {
    final queue = StreamQueue<Future<T> Function()>(Stream.fromIterable(tasks));

    final processors = List<Future<List<T>>>.generate(
      min(concurrency, tasks.length),
      (_) => _processQueue(queue, resultWaiter),
    );
    final result = await Future.wait(processors);
    await queue.cancel();
    return result.expand((element) => element).toList();
  }

  Future<List<T>> _processQueue(
    StreamQueue<Future<T> Function()> queue,
    Future Function(T)? resultWaiter,
  ) async {
    final List<T> results = [];
    while (await queue.hasNext) {
      late final Future<T> Function()? task;
      try {
        task = await queue.next;
      } catch (_) {
        task = null;
      }
      if (task == null) continue;
      final result = await task();
      results.add(result);
      if (resultWaiter != null) {
        await resultWaiter(result);
      }
    }
    return results;
  }
}
