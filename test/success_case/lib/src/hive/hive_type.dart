import 'package:hive/hive.dart';

part 'hive_type.hive.dart';

@HiveType(typeId: 1)
class HivePerson {
  HivePerson(this.test);
  @HiveField(0)
  final String test;
}
