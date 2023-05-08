import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injectable_init.config.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
void configureInjection(String env) async {
  $initGetIt(getIt, environment: env);
}
