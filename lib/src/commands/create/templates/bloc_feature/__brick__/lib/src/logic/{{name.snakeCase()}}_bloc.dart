import 'package:bloc/bloc.dart';
import './{{name.snakeCase()}}_event.dart';
import './{{name.snakeCase()}}_state.dart';

class {{name.pascalCase()}}Bloc extends Bloc<{{name.pascalCase()}}Event, {{name.pascalCase()}}State> {
  {{name.pascalCase()}}Bloc() : super({{name.pascalCase()}}State()) {
    // Add Your Events Here
  }
}