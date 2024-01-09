import 'package:firebase_database/firebase_database.dart';

class CategoryData {
  // Reference to each "category" node
  DatabaseReference getCategoriesRef(int index) {
    return FirebaseDatabase.instance.ref().child('categories').child('$index');
  }

  Future<List> getAllCategories() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('categories');
    DatabaseEvent event = await ref.once();
    DataSnapshot snapshot = event.snapshot;
    int categoriesLength = 0;

    if (snapshot.value != null) {
      List<dynamic>? categoriesData = snapshot.value as List<dynamic>?;

      if (categoriesData != null) {
        categoriesLength = categoriesData.length;
      }
    }

    List<Future<DataSnapshot>> futures = [];

    // Create a list of futures for each coupon reference
    for (int i = 0; i < categoriesLength; i++) {
      DatabaseReference categoryRef = getCategoriesRef(i);
      futures.add(
          categoryRef.once().then((DatabaseEvent event) => event.snapshot));
    }

    // Wait for all futures to complete
    List<DataSnapshot> snapshots = await Future.wait(futures);

    // Convert DataSnapshots to List<Map<dynamic, dynamic>>
    List categories = snapshots.map((snapshot) {
      Map<dynamic, dynamic>? categoryData =
          snapshot.value as Map<dynamic, dynamic>?;

      dynamic categoryName = categoryData?['name'];
      return categoryName ?? '';
    }).toList();

    return categories;
  }
}
