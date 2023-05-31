const command = 'fcm-tester';
const fileName = 'fcm_tester.json';
const serverKey = 'mockServerKey';

const Map<String, dynamic> jsonReuest = {
  'serverKey': serverKey,
  'request': {
    "token": "mockToken",
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
      'serverKey': serverKey,
      'request': null,
    },
  ),
  IvalidJsonCase(
    when: 'request is empty',
    request: {
      'serverKey': serverKey,
      'request': {},
    },
  ),
  IvalidJsonCase(
    when: 'request is not Map<String, dynamic>',
    request: {
      'serverKey': serverKey,
      'request': 1,
    },
  ),
];
