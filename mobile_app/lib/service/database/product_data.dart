import 'package:firebase_database/firebase_database.dart';

class ProductData {
  // Reference to each "product" node
  DatabaseReference getProductsRef() {
    return FirebaseDatabase.instance.ref().child('products');
  }

  Future<List<Map<String, dynamic>>> getProductData(int categoryId) async {
    DatabaseReference ref = getProductsRef();

    // Pobierz dane z bazy danych
    DatabaseEvent event = await ref.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value == null) {
      return [];
    } else {
      List<Map<String, dynamic>> products = [];

      // Iteracja przez wszystkie elementy w snapshocie
      (snapshot.value as Map).forEach((key, value) {
        if (value['category_id'] == categoryId) {
          products.add({
            'id': value['id'],
            'category_id': value['category_id'],
            'name': value['name'],
            'price': value['price'],
            'details': value['details'],
            'images': value['images']
          });
        }
      });

      return products;
    }
  }

  Future<List<Map<String, dynamic>>> getProductDataByName(String name) async {
    DatabaseReference ref = getProductsRef();

    // Pobierz dane z bazy danych
    DatabaseEvent event = await ref.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value == null) {
      return [];
    } else {
      List<Map<String, dynamic>> products = [];

      // Iteracja przez wszystkie elementy w snapshocie
      (snapshot.value as Map).forEach((key, value) {
        if (value['name']
            .toLowerCase()
            .trim()
            .contains(name.toLowerCase().trim())) {
          products.add({
            'id': value['id'],
            'category_id': value['category_id'],
            'name': value['name'],
            'price': value['price'],
            'details': value['details'],
            'images': value['images']
          });
        }
      });

      return products;
    }
  }

  Future<Map<String, dynamic>> getProductDataById(String id) async {
    DatabaseReference ref = getProductsRef();

    DatabaseEvent event = await ref.child(id).once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value == null) {
      return {};
    } else {
      final product =
          Map<String, dynamic>.from(snapshot.value! as Map<Object?, Object?>);

      return product;
    }
  }

  Future<int> getProductDataByNameLength(String name) async {
    DatabaseReference ref = getProductsRef();

    // Pobierz dane z bazy danych
    DatabaseEvent event = await ref.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value == null) {
      return 0;
    } else {
      List<Map<String, dynamic>> products = [];

      // Iteracja przez wszystkie elementy w snapshocie
      (snapshot.value as Map).forEach((key, value) {
        if (value['name']
            .toLowerCase()
            .trim()
            .contains(name.toLowerCase().trim())) {
          products.add({
            'id': value['id'],
            'category_id': value['category_id'],
            'name': value['name'],
            'price': value['price'],
            'details': value['details'],
            'images': value['images']
          });
        }
      });

      return products.length;
    }
  }
}
