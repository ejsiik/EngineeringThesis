import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/service/chat/message.dart';

void main() {
  test('Message class should correctly convert to map', () {
    final message = Message(
      senderId: 'senderId',
      senderEmail: 'sender@example.com',
      receiverId: 'receiverId',
      message: 'Hello, world!',
      timestamp: Timestamp.now(),
    );

    final messageMap = message.toMap();

    expect(messageMap['senderId'], 'senderId');
    expect(messageMap['senderEmail'], 'sender@example.com');
    expect(messageMap['receiverId'], 'receiverId');
    expect(messageMap['message'], 'Hello, world!');
  });

  test('Message class should correctly be created from map', () {
    final messageMap = {
      'senderId': 'senderId',
      'senderEmail': 'sender@example.com',
      'receiverId': 'receiverId',
      'message': 'Hello, world!',
      'timestamp': Timestamp.now(),
    };

    final message = Message.fromMap(messageMap);

    expect(message.senderId, 'senderId');
    expect(message.senderEmail, 'sender@example.com');
    expect(message.receiverId, 'receiverId');
    expect(message.message, 'Hello, world!');
  });
}
