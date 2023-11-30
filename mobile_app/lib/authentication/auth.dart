import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../database/data.dart';

class Auth extends GetxController {
  static Auth get instance => Get.find();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  // Listen to authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

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
      return e.message; // Return the error message if there's an exception
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

      // Call the instance method on the created instance
      await data.createUserInDatabase(email: email.trim(), name: name.trim());
    } on FirebaseAuthException catch (e) {
      return e.message;
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
          return "User is already verified.";
        } else {
          await currentUser!.sendEmailVerification();
        }
      }
    } catch (error) {
      return 'Error sending verification email: $error';
    }
  }

  Future<bool> checkEmailVerified() async {
    try {
      await currentUser!.reload();
      return currentUser != null ? currentUser!.emailVerified : false;
    } catch (error) {
      throw 'Error checking email verification status: $error';
    }
  }

  Future<String?> passwordReset({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      return null; // Return null on success
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
