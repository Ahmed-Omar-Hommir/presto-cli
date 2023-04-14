class CommandModel {
  const CommandModel({
    required this.name,
    required this.description,
  });
  final String name;
  final String description;
}

List<CommandModel> commands = [
  CommandModel(
    name: 'packages',
    description: 'Show all packages in project',
  ),
  CommandModel(
    name: 'help',
    description: 'Print this usage information.',
  ),
];
