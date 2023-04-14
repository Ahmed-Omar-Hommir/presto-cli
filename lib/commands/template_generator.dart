import 'package:mason/mason.dart';

abstract class TemplateGenerator<T> {
  Future<void> generate({required T vars});
  Brick get brick;
}
