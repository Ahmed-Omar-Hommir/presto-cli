import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:presto_cli/presto_cli.dart';
import 'package:test/test.dart';

import '../mocks.mocks.dart';
import 'helper.dart';

void main() {
  late IFcmService sut;
  late MockFcmRemoteServiceApi mockApi;

  setUp(() {
    mockApi = MockFcmRemoteServiceApi();
    sut = FcmService(api: mockApi);
  });

  group('Success case', () {
    test(
      'should return a Right when the request is successful',
      () async {
        // Arrange
        whenSendNotification(
          mockApi: mockApi,
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await sut.sendNotification(
          data: sendNotificationRequest,
          serverKey: serverKey,
        );

        // Assert
        expect(result, isA<Right>());

        verifySendNotification(
          mockApi: mockApi,
        ).called(1);

        verifyNoMoreInteractions(mockApi);
      },
    );
  });
  group('Failure cases', () {
    test(
      'should return a Left when the request fails',
      () async {
        // Arrange

        whenSendNotification(
          mockApi: mockApi,
        ).thenThrow(Exception());

        // Act
        final result = await sut.sendNotification(
          data: sendNotificationRequest,
          serverKey: serverKey,
        );

        // Assert
        expect(result, isA<Left>());

        verifySendNotification(
          mockApi: mockApi,
        ).called(1);

        verifyNoMoreInteractions(mockApi);
      },
    );
  });
}
