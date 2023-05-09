library {{name.snakeCase()}};


export 'src/{{name.snakeCase()}}_composer.dart';
{{#useLocalization}}
export 'src/l10n/{{name.snakeCase()}}_localizations.dart';
{{/useLocalization}}