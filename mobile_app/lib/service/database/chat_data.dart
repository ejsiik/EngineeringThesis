import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/service/chat/message.dart';

class ChatData {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  // instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<dynamic> createUserInDatabase({
    required String email,
  }) async {
    try {
      if (currentUser != null) {
        // Get the user ID
        String userId = currentUser!.uid;

        _firestore.collection('users').doc(userId).set({
          'uid': userId,
          'email': email,
        }, SetOptions(merge: true));
        // Provide some feedback to the user (you can customize this)
        return 'Account created successfully!';
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  addMessageToDatabase({
    required String chatRoomId,
    required Message message,
  }) {
    _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(message.toMap());
  }

  getMessages({
    required String chatRoomId,
  }) {
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
