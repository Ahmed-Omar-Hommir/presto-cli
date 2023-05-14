class PackageDependency {
  PackageDependency({
    required this.name,
    required this.version,
  });
  final String name;
  final String? version;

  String get dependency => '$name:$version';
}
