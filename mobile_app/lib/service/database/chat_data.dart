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
        return 'Konto zostało pomyślnie utworzone!';
      }
    } on FirebaseAuthException {
      return 'Błąd podczas tworzenia konta';
    }
  }

  Future<String> deleteUser() async {
    try {
      if (currentUser != null) {
        // Get the user ID
        String userId = currentUser!.uid;

        // Delete the user document from the 'users' collection
        await _firestore.collection('users').doc(userId).delete();
        return 'Konto zostało pomyślnie usunięte!';
      } else {
        return 'Użytkownik nie jest zalogowany.';
      }
    } catch (e) {
      return 'Błąd podczas usuwania konta: $e';
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

  Stream<List<Map<String, String>>> getAllUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'email': doc['email'].toString(),
        };
      }).toList();
    });
  }
}
