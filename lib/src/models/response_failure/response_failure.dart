import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_failure.freezed.dart';

@freezed
class ResponseFailure with _$ResponseFailure {
  const factory ResponseFailure.badRequest(Map<String, dynamic> json) =
      BadRequest;

  const factory ResponseFailure.unauthorized(Map<String, dynamic> json) =
      Unauthorized;

  const factory ResponseFailure.notFound() = NotFound;

  const factory ResponseFailure.unprocessable(Map<String, dynamic> json) =
      UnprocessableFailure;

  const factory ResponseFailure.paymentRequired(Map<String, dynamic> json) =
      PaymentRequired;

  const factory ResponseFailure.internalServerError() = InternalServerError;

  const factory ResponseFailure.serviceUnavailable() = ServiceUnavailable;

  const factory ResponseFailure.requestCancelled() = RequestCancelled;

  const factory ResponseFailure.methodNotAllowed() = MethodNotAllowed;

  const factory ResponseFailure.notAcceptable() = NotAcceptable;

  const factory ResponseFailure.requestTimeout() = RequestTimeout;

  const factory ResponseFailure.sendTimeout() = SendTimeout;

  const factory ResponseFailure.receiveTimeout() = ReceiveTimeout;

  const factory ResponseFailure.conflict(Map<String, dynamic> json) = Conflict;

  const factory ResponseFailure.notImplemented() = NotImplemented;

  const factory ResponseFailure.noInternetConnection() = NoInternetConnection;

  const factory ResponseFailure.formatException() = FormatException;

  const factory ResponseFailure.forbidden(Map<String, dynamic> json) =
      Forbidden;

  const factory ResponseFailure.defaultError(String error) = DefaultError;

  const factory ResponseFailure.unexpectedError() = UnexpectedError;

  const factory ResponseFailure.unknownError() = UnknownError;
}

extension Message on ResponseFailure {
  String get messageString {
    return 'unknown error';
  }
}
