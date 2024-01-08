import 'package:firebase_database/firebase_database.dart';

class ShopLocationData {
  // Reference to each "location" node
  DatabaseReference getShopsLocationsRef(int index) {
    return FirebaseDatabase.instance
        .ref()
        .child('shops_locations')
        .child('$index');
  }

  Future<List> getAllShopsLocations() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child('shops_locations');
    DatabaseEvent event = await ref.once();
    DataSnapshot snapshot = event.snapshot;
    int shopsLocationsLength = 0;

    if (snapshot.value != null) {
      List<dynamic>? shopsLocationsData = snapshot.value as List<dynamic>?;

      if (shopsLocationsData != null) {
        shopsLocationsLength = shopsLocationsData.length;
      }
    }

    List<Future<DataSnapshot>> futures = [];

    // Create a list of futures for each coupon reference
    for (int i = 0; i < shopsLocationsLength; i++) {
      DatabaseReference shopLocationRef = getShopsLocationsRef(i);
      futures.add(
          shopLocationRef.once().then((DatabaseEvent event) => event.snapshot));
    }

    // Wait for all futures to complete
    List<DataSnapshot> snapshots = await Future.wait(futures);

    // Convert DataSnapshots to List<Map<dynamic, dynamic>>
    List<Map<dynamic, dynamic>> shopsLocations = snapshots.map((snapshot) {
      Map<dynamic, dynamic>? shopLocationData =
          snapshot.value as Map<dynamic, dynamic>?;
      return shopLocationData ?? {};
    }).toList();

    return shopsLocations;
  }
}
