import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presto_cli/src/models/response_failure/response_failure.dart';
import 'package:retrofit/retrofit.dart';

part 'fcm_service.g.dart';

abstract class IFcmService {
  Future<Either<ResponseFailure, None>> sendNotification({
    required Map<String, dynamic> data,
    required String serverKey,
  });
}

class FcmService implements IFcmService {
  FcmService({
    @visibleForTesting FcmRemoteServiceApi? api,
  }) : _api = api ?? FcmRemoteServiceApi(Dio());

  final FcmRemoteServiceApi _api;

  @override
  Future<Either<ResponseFailure, None>> sendNotification({
    required Map<String, dynamic> data,
    required String serverKey,
  }) async {
    try {
      await _api.sendNotification(
        data: data,
        serverKey: 'key=$serverKey',
      );
      return right(None());
    } catch (e) {
      print(e);
      // Todo: use hander error
      return left(ResponseFailure.unknownError());
    }
  }
}

abstract class FcmUrls {
  static const sendNotificationUrl = 'https://fcm.googleapis.com/fcm/send';
}

@RestApi()
abstract class FcmRemoteServiceApi {
  factory FcmRemoteServiceApi(Dio dio) = _FcmRemoteServiceApi;

  @POST(FcmUrls.sendNotificationUrl)
  Future<void> sendNotification({
    @Body() required Map<String, dynamic> data,
    @Header('Authorization') required String serverKey,
  });
}
