import 'package:mockito/mockito.dart';

import '../mocks.mocks.dart';

final sendNotificationUrl = 'https://fcm.googleapis.com/fcm/send';
const Map<String, dynamic> sendNotificationRequest = {};
const serverKey = 'mockServerKey';
const deviceTokens = ['mockDeviceToken'];

PostExpectation<void> whenSendNotification({
  required MockFcmRemoteServiceApi mockApi,
}) {
  return when(mockApi.sendNotification(
    data: sendNotificationRequest,
    serverKey: "key=$serverKey",
  ));
}

VerificationResult verifySendNotification({
  required MockFcmRemoteServiceApi mockApi,
}) {
  return verify(mockApi.sendNotification(
    data: sendNotificationRequest,
    serverKey: "key=$serverKey",
  ));
}
