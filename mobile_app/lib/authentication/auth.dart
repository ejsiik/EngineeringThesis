import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      await createUserInDatabase(email: email.trim(), name: name.trim());
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    return null;
  }

  Future<dynamic> createUserInDatabase({
    required String email,
    required String name,
  }) async {
    try {
      if (currentUser != null) {
        // Get the user ID
        String userId = currentUser!.uid;

        // Create a reference to the "users" node in the Realtime Database
        DatabaseReference usersRef =
            FirebaseDatabase.instance.ref().child('users');

        DateTime currentDate = DateTime.now().toUtc();

        // Create a new record for the user
        await usersRef.child(userId).set({
          'email': email,
          'Id': userId,
          'name': name,
          'createdAt': currentDate.toString(),
          'couponUsed': false,
          'coupons': {
            'coupon1': {
              'wasUsed': false,
              'couponValue': 0,
            },
            'coupon2': {
              'wasUsed': false,
              'couponValue': 0,
            },
            'coupon3': {
              'wasUsed': false,
              'couponValue': 0,
            },
            'coupon4': {
              'wasUsed': false,
              'couponValue': 0,
            },
            'coupon5': {
              'wasUsed': false,
              'couponValue': 0,
            },
            'coupon6': {
              'wasUsed': false,
              'couponValue': 0,
            },
          },
        });
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
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
