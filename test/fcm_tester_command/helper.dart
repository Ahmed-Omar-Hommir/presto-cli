import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';

import '../mocks.mocks.dart';

const command = 'fcm-test';
const fileName = 'fcm_test.json';

const Map<String, dynamic> jsonReuest = {
  'serverKey': 'mockServerKey',
  'request': {
    "to": "mockToken",
    "notification": {
      "title": "Match update",
      "body": "Arsenal goal in added time, score is now 3-0"
    },
    'data': {
      'title': 'mockTitle',
      'body': 'mockBody',
    },
  },
};

class IvalidJsonCase {
  IvalidJsonCase({
    required this.request,
    required this.when,
  });
  final String when;
  final Map<String, dynamic> request;
}

final List<IvalidJsonCase> invalidJsonServerKeyCases = [
  IvalidJsonCase(
    when: 'serverKey is null',
    request: {
      'serverKey': null,
      'request': jsonReuest['request'],
    },
  ),
  IvalidJsonCase(
    when: 'serverKey is empty',
    request: {
      'serverKey': '',
      'request': jsonReuest['request'],
    },
  ),
  IvalidJsonCase(
    when: 'serverKey is not string',
    request: {
      'serverKey': 1,
      'request': jsonReuest['request'],
    },
  ),
];

final List<IvalidJsonCase> invalidJsonRequestCases = [
  IvalidJsonCase(
    when: 'request is null',
    request: {
      'serverKey': jsonReuest['serverKey'],
      'request': null,
    },
  ),
  IvalidJsonCase(
    when: 'request is empty',
    request: {
      'serverKey': jsonReuest['serverKey'],
      'request': {},
    },
  ),
  IvalidJsonCase(
    when: 'request is not Map<String, dynamic>',
    request: {
      'serverKey': jsonReuest['serverKey'],
      'request': 1,
    },
  ),
];

PostExpectation<Future<Either<String, None>>> whenSendNotification({
  required MockIFcmService mockIFcmService,
  Map<String, dynamic>? data,
  String? serverKey,
}) {
  return when(mockIFcmService.sendNotification(
    serverKey: serverKey ?? jsonReuest['serverKey'],
    data: data ?? jsonReuest['request'],
  ));
}

VerificationResult verifySendNotification({
  required MockIFcmService mockIFcmService,
  Map<String, dynamic>? data,
  String? serverKey,
}) {
  return verify(mockIFcmService.sendNotification(
    data: data ?? jsonReuest['request'],
    serverKey: serverKey ?? jsonReuest['serverKey'],
  ));
}
