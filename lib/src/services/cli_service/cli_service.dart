import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:retrofit/retrofit.dart';

part 'cli_service.g.dart';

abstract class ICliService {
  Future<Either<String, String>> getLastVersion();
}

class CliService implements ICliService {
  CliService({
    @visibleForTesting CliRemoteServiceApi? api,
  }) : _api = api ?? CliRemoteServiceApi(Dio());

  final CliRemoteServiceApi _api;

  @override
  Future<Either<String, String>> getLastVersion() async {
    try {
      final content = await _api.getVersionDartFile();
      final version = _extractVersion(content);

      if (version == null) return left(CliServiceMessage.versionFileNotFound);

      return right(version);
    } catch (e) {
      return left(e.toString());
    }
  }

  String? _extractVersion(String content) {
    RegExp versionPattern = RegExp(r"'([^']*)'");
    Match? match = versionPattern.firstMatch(content);
    return match?.group(1);
  }
}

@RestApi()
abstract class CliRemoteServiceApi {
  factory CliRemoteServiceApi(Dio dio) = _CliRemoteServiceApi;

  @GET(RemoteRepositoryInfo.versionUrl)
  Future<String> getVersionDartFile();
}

abstract class CliServiceMessage {
  static const versionFileNotFound = 'Version file not found';
}
