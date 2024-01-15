import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/service/database/data.dart';

class OrderData {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  // Listen to authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child('orders');

  Future<void> addOrder(String name, String surname,
      Map<String, dynamic> location, double totalPrice) async {
    try {
      String userId = currentUser!.uid;

      String city = location['city'];
      String street = location['street'];
      String streetNumber = location['street_number'];

      Data userData = Data();
      List<dynamic> data = await userData.getShoppingListData();

      DateTime now = DateTime.now();
      String formattedDate = now.toLocal().toString();

      DatabaseReference userOrderRef = ordersRef.child(userId).push();
      await userOrderRef.set({
        'is_completed': false,
        'order': {
          'user_id': userId,
          'user_name': name,
          'user_surname': surname,
          'city': city,
          'street': street,
          'street_number': streetNumber,
          'total_price': totalPrice,
          'shopping_list': data,
          'order_date': formattedDate,
        },
      });

      await userData.deleteShoppingList();
    } catch (error) {
      throw Exception('Error accesing shopping cart: $error');
    }
  }

  Future<List<Map<String, dynamic>>> getOrderList(String type) async {
    try {
      String userId = currentUser!.uid;

      DatabaseEvent orderEvent = await ordersRef.child(userId).once();
      DataSnapshot orderSnapshot = orderEvent.snapshot;

      if (orderSnapshot.value == null) {
        return [];
      }

      final ordersData = Map<String, dynamic>.from(
          orderSnapshot.value! as Map<Object?, Object?>);

      List<Map<String, dynamic>> orders = [];

      if (type == 'activeOrders') {
        ordersData.forEach((key, order) {
          // Check if the order is not completed
          if (order['is_completed'] == false) {
            orders.add({key: order});
          }
        });

        return orders;
      } else if (type == 'completedOrders') {
        ordersData.forEach((key, order) {
          // Check if the order is not completed
          if (order['is_completed'] == true) {
            orders.add({key: order});
          }
        });

        return orders;
      } else {
        return [];
      }
    } catch (error) {
      throw Exception('Error accesing shopping cart: $error');
    }
  }

  Future<List<Map<String, dynamic>>> getOrderListById(
      String type, String id) async {
    try {
      DatabaseEvent orderEvent = await ordersRef.child(id).once();
      DataSnapshot orderSnapshot = orderEvent.snapshot;

      if (orderSnapshot.value == null) {
        return [];
      }

      final ordersData = Map<String, dynamic>.from(
          orderSnapshot.value! as Map<Object?, Object?>);

      List<Map<String, dynamic>> orders = [];

      if (type == 'activeOrders') {
        ordersData.forEach((key, order) {
          // Check if the order is not completed
          if (order['is_completed'] == false) {
            orders.add({key: order});
          }
        });

        return orders;
      } else if (type == 'completedOrders') {
        ordersData.forEach((key, order) {
          // Check if the order is not completed
          if (order['is_completed'] == true) {
            orders.add({key: order});
          }
        });

        return orders;
      } else {
        return [];
      }
    } catch (error) {
      throw Exception('Error accesing shopping cart: $error');
    }
  }

  Future<Map<dynamic, dynamic>> getProductData(String productId) async {
    try {
      DatabaseReference productsRef =
          FirebaseDatabase.instance.ref().child('products/$productId');
      DatabaseEvent productEvent = await productsRef.once();
      DataSnapshot productSnapshot = productEvent.snapshot;
      final product = Map<dynamic, dynamic>.from(
          productSnapshot.value! as Map<Object?, Object?>);

      return product;
    } catch (error) {
      throw Exception('Error accesing shopping cart: $error');
    }
  }

  Future<Map<String, String>> getUsersId() async {
    try {
      DatabaseEvent orderEvent = await ordersRef.once();
      DataSnapshot orderSnapshot = orderEvent.snapshot;

      final data = Map<String, dynamic>.from(
          orderSnapshot.value as Map<Object?, Object?>);
      final Map<String, String> usersMap = {};

      await Future.forEach(data.keys, (element) async {
        DatabaseReference usersRef =
            FirebaseDatabase.instance.ref().child('users/$element');
        DatabaseEvent userEvent = await usersRef.once();
        DataSnapshot userSnapshot = userEvent.snapshot;

        final user = Map<String, dynamic>.from(
            userSnapshot.value as Map<Object?, Object?>);

        String username = user['name'];

        usersMap[element] = username;
      });

      print(usersMap);
      return usersMap;
    } catch (error) {
      throw Exception('Error accesing shopping cart: $error');
    }
  }

  Future<void> makeCompleted(String userId, String orderId) async {
    try {
      await ordersRef
          .child("${userId}/${orderId}")
          .update({'is_completed': true});
    } catch (error) {
      throw Exception('Error accesing shopping cart: $error');
    }
  }

  Future<String> deleteUser() async {
    try {
      if (currentUser != null) {
        String userId = currentUser!.uid;

        await ordersRef.child(userId).remove();
      }
    } catch (e) {
      return 'Błąd podczas usuwania zamówień użytkownika: $e';
    }
    return "Dane zamówień użytkownika pomyślnie usunięte z bazy danych";
  }
}
