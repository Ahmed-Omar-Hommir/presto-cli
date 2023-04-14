import 'package:flutter/material.dart';

import './{{name.snakeCase()}}_page.dart';

abstract class {{name.pascalCase()}}Composer {
  static Widget compose{{name.pascalCase()}}Page(){
    return {{name.pascalCase()}}Page();
  }
}
