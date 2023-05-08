import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'rest_api.g.dart';

@RestApi()
abstract class Service {
  factory Service(Dio dio) = _Service;
}
