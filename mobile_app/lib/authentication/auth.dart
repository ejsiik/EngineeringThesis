import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../database/data.dart';

class Auth extends GetxController {
  static Auth get instance => Get.find();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  // Listen to authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

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
      // Create user in the Realtime Database
      await data.createUserInDatabase(
        email: user!.email!,
        name: user.displayName!,
      );
      // Return the UserCredential
      return authResult;
    } on FirebaseAuthException catch (e) {
      return e.message;
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
