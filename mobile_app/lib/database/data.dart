import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Data {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  // Listen to authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  // Create a reference to the "users" node in the Realtime Database
  DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');

  DatabaseReference getCouponRef(int index) {
    return FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(currentUser!.uid)
        .child('coupons')
        .child('coupon${index + 1}');
  }

  Future<List<Map<dynamic, dynamic>>> getAllCouponData() async {
    try {
      if (currentUser != null) {
        List<Future<DataSnapshot>> futures = [];

        // Create a list of futures for each coupon reference
        for (int i = 0; i < 6; i++) {
          DatabaseReference couponRef = getCouponRef(i);
          futures.add(
              couponRef.once().then((DatabaseEvent event) => event.snapshot));
        }

        // Wait for all futures to complete
        List<DataSnapshot> snapshots = await Future.wait(futures);

        // Convert DataSnapshots to List<Map<dynamic, dynamic>>
        List<Map<dynamic, dynamic>> coupons = snapshots.map((snapshot) {
          Map<dynamic, dynamic>? couponData =
              snapshot.value as Map<dynamic, dynamic>?;
          return couponData ?? {};
        }).toList();

        return coupons;
      }
    } on FirebaseAuthException {
      rethrow;
    }
    return [];
  }

  Future<String> generateQRCodeData() async {
    try {
      if (currentUser != null) {
        String userId = currentUser!.uid;
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child('users').child(userId);
        DatabaseEvent event = await userRef.once();
        DataSnapshot snapshot = event.snapshot;

        if (snapshot.value != null) {
          return userId;
        } else {
          throw Exception('Error fetching user data');
        }
      } else {
        throw Exception('User is not signed in');
      }
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<String?> getUserName() async {
    try {
      if (currentUser != null) {
        // Get the user ID
        String userId = currentUser!.uid;
        // Get the user's data from the database
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child('users').child(userId);
        // Use `once()` to get the DatabaseEvent
        DatabaseEvent event = await userRef.once();

        // Extract DataSnapshot from the DatabaseEvent
        DataSnapshot snapshot = event.snapshot;
        if (snapshot.value != null) {
          Map<dynamic, dynamic>? userData = snapshot.value as Map?;
          String name = userData?['name'];
          return name;
        }
      }
    } on FirebaseAuthException catch (e) {
      return ('Error getting user name: ${e.message}');
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
}
