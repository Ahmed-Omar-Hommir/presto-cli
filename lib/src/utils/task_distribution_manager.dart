abstract class ITaskDistributionManager<T> {
  List<List<T>> distributeTasks({
    required int numberOfIsolates,
    required List<T> tasks,
  });
}

class TaskDistributionManager<T> implements ITaskDistributionManager<T> {
  const TaskDistributionManager();
  @override
  List<List<T>> distributeTasks({
    required int numberOfIsolates,
    required List<T> tasks,
  }) {
    final containers = List.generate(
      numberOfIsolates > tasks.length ? tasks.length : numberOfIsolates,
      (_) => <T>[],
    );

    for (var i = 0; i < tasks.length; i++) {
      containers[i % containers.length].add(tasks[i]);
    }

    return containers;
  }
}
