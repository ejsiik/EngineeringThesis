import 'package:flutter/material.dart';
import 'package:mobile_app/service/database/order_data.dart';
import 'package:mobile_app/screens/user/category_products_page/product_details_page.dart';

class OrderDetailsPage extends StatelessWidget {
  final List<Object?> order;

  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);

  Future<Map<dynamic, dynamic>> getProductData(String id) async {
    OrderData orderData = OrderData();
    Map<dynamic, dynamic> data = await orderData.getProductData(id);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zakupione produkty'),
      ),
      body: ListView.builder(
        itemCount: order.length,
        itemBuilder: (context, index) {
          final product =
              Map<String, dynamic>.from(order[index] as Map<Object?, Object?>);

          return FutureBuilder<Map<dynamic, dynamic>>(
            future: getProductData(product['product_id']),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListTile(
                  title: Text('Produkt #${index + 1} - Wczytywanie...'),
                );
              } else if (snapshot.hasError) {
                return ListTile(
                  title: Text('Produkt #${index + 1} - Błąd wczytywania'),
                );
              } else if (!snapshot.hasData || snapshot.data == null) {
                return ListTile(
                  title:
                      Text('Produkt #${index + 1} - Brak danych o produkcie'),
                );
              } else {
                final productData = snapshot.data!;

                return Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text(productData['name'] ?? 'Brak nazwy produktu'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ilość: ${product['quantity']}'),
                        Text('Cena całkowita: ${product['price']} zł'),
                      ],
                    ),
                    onTap: () {
                      final details = Map<String, dynamic>.from(
                          productData['details'] as Map<Object?, Object?>);
                      final images = Map<String, dynamic>.from(
                          productData['images'] as Map<Object?, Object?>);
                      // Navigacja do ProductDetailsPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(
                              productData['category_id'],
                              productData['id'],
                              productData['name'],
                              productData['price'],
                              details,
                              images,
                              "/ordersPage"),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
