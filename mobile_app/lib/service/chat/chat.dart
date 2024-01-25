import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/service/authentication/auth.dart';
import 'package:mobile_app/service/chat/message.dart';
import 'package:mobile_app/service/database/chat_data.dart';

class Chat extends ChangeNotifier {
  // Send message
  Future<void> sendMessage(String receiverId, String message) async {
    // get current user id
    final String userId = Auth().userId();
    final String? userEmail = Auth().userEmail();
    final timestamp = Timestamp.now();

    // create message
    Message newMessage = Message(
        senderId: userId,
        senderEmail: userEmail!,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp);

    // chat room id
    String chatRoomId = generateChatRoomId(userId, receiverId);

    // add to database
    ChatData()
        .addMessageToDatabase(chatRoomId: chatRoomId, message: newMessage);
  }

  // Get messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    // chat room id
    String chatRoomId = generateChatRoomId(userId, otherUserId);

    return ChatData().getMessages(chatRoomId: chatRoomId);
  }

  // Generate chat room id based on user IDs
  String generateChatRoomId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();
    String chatRoomId = ids.join("_");
    return chatRoomId;
  }
}
