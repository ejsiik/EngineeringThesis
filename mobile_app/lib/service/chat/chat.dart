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
    List<String> ids = [userId, receiverId];
    ids.sort(); // chat room is the same for pair of users
    String chatRoomId = ids.join("_"); // combine ids into String

    // add to database
    ChatData()
        .addMessageToDatabase(chatRoomId: chatRoomId, message: newMessage);
  }

  // Get messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return ChatData().getMessages(chatRoomId: chatRoomId);
  }
}
