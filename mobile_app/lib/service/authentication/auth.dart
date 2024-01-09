import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_app/service/database/chat_data.dart';

import '../database/data.dart';

class Auth extends GetxController {
  static Auth get instance => Get.find();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  // Listen to authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  String userId() {
    return currentUser!.uid;
  }

  String? userEmail() {
    return currentUser!.email.toString();
  }

  // Delete user account from Firebase Authentication
  Future<String> deleteUser() async {
    try {
      User? currentUser = _firebaseAuth.currentUser;

      if (currentUser != null) {
        await currentUser.delete();
      }
    } catch (e) {
      return "Błąd podczas usuwania użytkownika";
    }
    return "Użytkownik został pomyślnie usunięty";
  }

  googleSignIn() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      // auth details from request
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Sign in with Firebase authentication
      UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Get the user information
      User? user = authResult.user;
      Data data = Data();
      ChatData chatData = ChatData();
      // Create user in the Realtime Database
      await data.createUserInDatabase(
        email: user!.email!,
        name: user.displayName!,
      );
      await chatData.createUserInDatabase(email: user.email!);
      // Return the UserCredential
      return authResult;
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseErrorToPolish(e.code);
    }
  }

  Future<String?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null; // Return null if the sign-in is successful
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseErrorToPolish(
          e.code); // Return the error message if there's an exception
    }
  }

  Future<dynamic> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      // Create an instance of the Data class
      Data data = Data();
      ChatData chatData = ChatData();

      // Call the instance method on the created instance
      await data.createUserInDatabase(email: email.trim(), name: name.trim());
      await chatData.createUserInDatabase(email: email.trim());
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseErrorToPolish(e.code);
    }
    return null;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<dynamic> sendVerificationEmail() async {
    try {
      if (currentUser != null) {
        if (currentUser!.emailVerified) {
          return "Użytkownik jest już zweryfikowany.";
        } else {
          await currentUser!.sendEmailVerification();
        }
      }
    } catch (error) {
      return 'Błąd podczas wysyłania e-maila weryfikacyjnego';
    }
  }

  Future<bool> checkEmailVerified() async {
    try {
      await currentUser!.reload();
      return currentUser != null ? currentUser!.emailVerified : false;
    } catch (error) {
      throw 'Błąd podczas sprawdzania statusu weryfikacji e-maila';
    }
  }

  Future<String?> passwordReset({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      return null; // Return null on success
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseErrorToPolish(e.code);
    }
  }

  // Map Firebase error codes to Polish error messages
  String _mapFirebaseErrorToPolish(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'Nie znaleziono użytkownika z podanym adresem e-mail';
      case 'wrong-password':
        return 'Nieprawidłowe hasło';
      case 'email-already-in-use':
        return 'Podany adres e-mail jest już używany';
      case 'invalid-email':
        return 'Podany adres e-mail jest nieprawidłowy';
      case 'weak-password':
        return 'Hasło jest zbyt słabe';
      default:
        return 'Wystąpił błąd uwierzytelniania';
    }
  }
}
