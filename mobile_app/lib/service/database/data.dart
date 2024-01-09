import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/service/authentication/auth.dart';

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
          throw Exception('Błąd podczas pobierania danych użytkownika');
        }
      } else {
        throw Exception('Użytkownik nie jest zalogowany');
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
      return ('Błąd podczas pobierania nazwy użytkownika: ${e.message}');
    }
    return null;
  }

  Future<void> updateUserName(String newName) async {
    try {
      // Update the name for the specified user
      await usersRef.child(Auth().userId()).update({
        'name': newName,
      });
    } catch (e) {
      print('Błąd podczas aktualizacji nazwy użytkownika: $e');
    }
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
        // Provide some feedback to the user
        return 'Konto zostało pomyślnie utworzone!';
      }
    } on FirebaseAuthException catch (e) {
      return 'Błąd podczas tworzenia konta: ${e.message}';
    }
  }

  Future<void> submitData(String userId, bool welcomeBanner, String couponValue,
      Function(String) onSubmitted) async {
    try {
      DatabaseReference usersRef =
          FirebaseDatabase.instance.ref().child('users');
      DatabaseEvent event = await usersRef.child(userId).once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        if (welcomeBanner) {
          await usersRef.child(userId).child('couponUsed').set(true);
          onSubmitted("Kupon powitalny został użyty");
        } else {
          if (couponValue.isNotEmpty) {
            int couponValueInt = int.tryParse(couponValue) ?? 0;

            // Example: Check for available coupons and update the database
            Map<dynamic, dynamic>? userData = snapshot.value as Map?;
            Map<dynamic, dynamic>? couponsData = userData?['coupons'] as Map?;

            if (couponsData != null) {
              // Find an unused coupon
              String? unusedCouponKey;
              for (String key in couponsData.keys) {
                if (couponsData[key]['wasUsed'] == false) {
                  unusedCouponKey = key;
                  break;
                }
              }

              if (unusedCouponKey != null) {
                // Update the unused coupon
                await usersRef
                    .child(userId)
                    .child('coupons')
                    .child(unusedCouponKey)
                    .update({
                  'wasUsed': true,
                  'couponValue': couponValueInt,
                });

                int usedCouponsCount = 0;
                couponsData.forEach((key, value) {
                  if (value['wasUsed'] == true) {
                    usedCouponsCount++;
                  }
                });

                if (usedCouponsCount >= 5) {
                  double totalCouponValue = 0;

                  couponsData.forEach((key, value) {
                    if (value['wasUsed'] == true) {
                      totalCouponValue += (value['couponValue'] as int);
                    }
                  });
                  // Check for the Average value of coupons
                  double meanCouponValue = totalCouponValue / 5;
                  // Set all coupons to false
                  couponsData.forEach((key, value) async {
                    await usersRef
                        .child(userId)
                        .child('coupons')
                        .child(key)
                        .update({
                      'wasUsed': false,
                      'couponValue': 0,
                    });
                  });

                  onSubmitted(
                      'Darmowy zakup! Średnia wartość: $meanCouponValue');
                } else {
                  onSubmitted('Kupon zaakceptowany');
                }
              } else {
                onSubmitted('Brak dostępnych kuponów');
              }
            } else {
              onSubmitted('Brak dostępnych kuponów');
            }
          } else {
            onSubmitted('Podaj cenę szkła');
          }
        }
      } else {
        throw Exception('Użytkownik nie znaleziony');
      }
    } catch (e) {
      throw Exception('Błąd podczas przesyłania danych: $e');
    }
  }

  // Function to delete the current user from Firebase Authentication and Realtime Database
  Future<String> deleteUser() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Delete user data from Realtime Database
        await usersRef.child(currentUser.uid).remove();
      }
    } catch (e) {
      return "Błąd podczas usuwania użytkownika z bazy danych: $e";
    }
    return "Dane użytkownika pomyślnie usunięte z bazy danych";
  }

  // Function to change the username in the Realtime Database
  Future<void> changeUserName(String newUsername) async {
    try {
      User? currentUser = _firebaseAuth.currentUser;

      if (currentUser != null) {
        // Update username in Realtime Database
        await usersRef.child(currentUser.uid).update({'name': newUsername});
      }
    } catch (e) {
      throw ("Błąd podczas zmiany nazwy użytkownika: $e");
    }
  }
}

class UserDataProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get user => _firebaseAuth.currentUser;

  Future<bool> isUserCreatedWithin14Days() async {
    if (user == null) return false;

    final firebaseCreationDate = DateTime.fromMillisecondsSinceEpoch(
        user!.metadata.creationTime!.millisecondsSinceEpoch);
    final currentDate = DateTime.now();
    final daysDifference = currentDate.difference(firebaseCreationDate).inDays;

    if (daysDifference <= 14) {
      final DatabaseEvent snapshotEvent = await FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(user!.uid)
          .child('couponUsed')
          .once();

      final DataSnapshot snapshot = snapshotEvent.snapshot;

      if (snapshot.value is bool && snapshot.value == false) {
        return true;
      }
    }

    return false;
  }

  DatabaseReference getCouponRef(int index) {
    return FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(user!.uid)
        .child('coupons')
        .child('coupon${index + 1}');
  }
}
