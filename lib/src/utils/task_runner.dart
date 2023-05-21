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
    StreamQueue<Future<T> Function()> queue =
        StreamQueue<Future<T> Function()>(Stream.fromIterable(tasks));

    final processors = List<Future<List<T>>>.generate(
      concurrency,
      (_) => _processQueue(queue, resultWaiter),
    );
    final result = await Future.wait(processors);
    return result.expand((element) => element).toList();
  }

  Future<List<T>> _processQueue(StreamQueue<Future<T> Function()> queue,
      Future Function(T)? resultWaiter) async {
    final List<T> results = [];
    while (await queue.hasNext) {
      final task = await queue.next;
      final result = await task();
      results.add(result);
      if (resultWaiter != null) {
        await resultWaiter(result);
      }
    }
    return results;
  }
}
