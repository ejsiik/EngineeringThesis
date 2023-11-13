import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth extends GetxController {
  static Auth get instance => Get.find();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

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
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    return null;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future sendVerificationEmail() async {
    try {
      // Check if currentUser is not null
      if (currentUser != null) {
        // Check if the user is already verified
        if (currentUser!.emailVerified) {
          return "User is already verified.";
        } else {
          // Send email verification
          await currentUser!.sendEmailVerification();
          return "Verification email sent successfully.";
        }
      } else {
        return "User not found.";
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException
      return e.message;
    }
  }

  Future<bool> checkEmailVerified() async {
    if (currentUser!.emailVerified) {
      return true;
    } else {
      return false;
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
