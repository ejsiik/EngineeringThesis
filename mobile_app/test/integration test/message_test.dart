import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:mobile_app/service/authentication/auth.dart';
import 'package:mobile_app/service/chat/chat.dart';

class MockAuth extends Auth {
  @override
  String userId() {
    return 'testUserId';
  }

  @override
  String userEmail() {
    return 'testUserEmail';
  }
}

void main() {
  group('Chat Service', () {
    late Chat chat;
    late FakeFirebaseFirestore mockFirestore;

    setUp(() {
      mockFirestore = FakeFirebaseFirestore();
      chat = Chat(auth: MockAuth());
    });

    test('should send a message', () async {
      final String testReceiverId = 'testReceiverId';
      final String testMessage = 'Hello, Test!';

      await chat.sendMessage(testReceiverId, testMessage);

      final snapshot = await mockFirestore.collection('messages').get();
      expect(snapshot.docs.length, 1);
      expect(snapshot.docs.first.get('message'), testMessage);
    });

    test('should get messages', () async {
      final String testSenderId = 'testSenderId';
      final String testReceiverId = 'testReceiverId';

      final stream = chat.getMessages(testSenderId, testReceiverId);
      expect(stream,
          isNotNull); // Add more assertions based on your implementation
    });

    test('should generate chat room id', () {
      final String testUserId1 = 'testUserId1';
      final String testUserId2 = 'testUserId2';

      final chatRoomId = chat.generateChatRoomId(testUserId1, testUserId2);
      expect(chatRoomId,
          'testUserId1_testUserId2'); // The ids are sorted and joined with '_'
    });
  });
}
