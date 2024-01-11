import 'package:firebase_database/firebase_database.dart';

class AddProduct {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('products');

  // Lista produktów do dodania
  List<Map<String, dynamic>> productsList = [];

  // Konstruktor klasy
  AddProduct() {
    //addProductsToDatabase();
  }

  // Dodawanie listy produktów do tabeli 'products'
  void addProductsToDatabase() {
    for (int i = 0; i < productsList.length; i++) {
      // Użyj metody push() do automatycznego generowania klucza (ID)
      DatabaseReference newProductRef = ref.push();
      // Pobierz klucz i dodaj go jako pole "id" do mapy produktu
      String? productId = newProductRef.key;
      productsList[i]['id'] = productId;
      // Dodaj mapę produktu do bazy danych
      newProductRef.set(productsList[i]);
    }
  }
}
