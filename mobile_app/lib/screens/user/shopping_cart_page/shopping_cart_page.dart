import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/service/database/data.dart';
import 'package:mobile_app/screens/user/category_products_page/product_details_page.dart';
import 'package:mobile_app/screens/user/orders_page/orders_page.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({Key? key}) : super(key: key);

  @override
  State<ShoppingCartPage> createState() {
    return _ShoppingCartPageState();
  }
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  Data userData = Data();
  static const String routeName = '/shoppingCartPage';
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    // Set up a listener for changes in the database
    getTotalPrice();
  }

  Future<void> getTotalPrice() async {
    double totalPriceData = await userData.getTotalPriceData();
    totalPrice = totalPriceData;
  }

  Future<List<dynamic>> getShoppingCartData() async {
    List<dynamic> data = await userData.getShoppingCartData();
    return data;
  }

  Future<Uint8List?> loadImage(String imageUrl) async {
    final ref = FirebaseStorage.instance.ref().child(imageUrl);
    final data = await ref.getData();
    return data;
  }

  Widget buildProductItem(Map productMap) {
    Future<void> addToShoppingCart(String productId) async {
      await userData.addToShoppingCart(productId);

      setState(() {});
    }

    Future<void> changeQuantityInShoppingCart(
        String productId, int quantity) async {
      await userData.changeQuantityInShoppingCart(productId, quantity);

      setState(() {});
    }

    Future<int> getQuantityOfShoppingCart(String productId) async {
      final data = await userData.getQuantityOfShoppingCart(productId);
      return data;
    }

    Map<String, dynamic> details =
        (productMap['details'] as Map<dynamic, dynamic>)
            .cast<String, dynamic>();
    Map<String, dynamic> images =
        (productMap['images'] as Map<dynamic, dynamic>).cast<String, dynamic>();

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: FutureBuilder(
          future: loadImage(images['img_1']),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Icon(Icons.error);
            } else {
              return Image.memory(
                snapshot.data!,
                width: 80,
                height: 80,
              );
            }
          },
        ),
        title: Text(productMap['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cena: ${productMap['price']} zł'),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () async {
                    int currentQuantity =
                        await getQuantityOfShoppingCart(productMap['id']);
                    if (currentQuantity > 1) {
                      setState(() {
                        currentQuantity--;
                      });
                      changeQuantityInShoppingCart(
                          productMap['id'], currentQuantity);
                    }
                  },
                ),
                FutureBuilder<int>(
                  future: getQuantityOfShoppingCart(productMap['id']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Icon(Icons.error);
                    } else {
                      int currentQuantity = snapshot.data!;
                      return Text('Ilość: $currentQuantity');
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    int currentQuantity =
                        await getQuantityOfShoppingCart(productMap['id']);
                    setState(() {
                      currentQuantity++;
                    });
                    changeQuantityInShoppingCart(
                        productMap['id'], currentQuantity);
                  },
                ),
              ],
            ),
            FutureBuilder<int>(
              future: getQuantityOfShoppingCart(productMap['id']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Icon(Icons.error);
                } else {
                  int currentQuantity = snapshot.data!;
                  return Text(
                      'Cena całkowita: ${(currentQuantity * productMap['price']).toStringAsFixed(2)} zł');
                }
              },
            ),
          ],
        ),
        trailing: GestureDetector(
          onTap: () {
            addToShoppingCart(productMap['id']);
          },
          child: const Icon(Icons.delete),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsPage(
                  productMap['category_id'],
                  productMap['id'],
                  productMap['name'],
                  productMap['price'],
                  details,
                  images,
                  routeName),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Koszyk'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List>(
              future: getShoppingCartData(),
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List? productsList = snapshot.data;
                  return ListView.builder(
                    itemCount: productsList?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildProductItem(productsList![index]);
                    },
                  );
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.orange,
            child: GestureDetector(
              onTap: () {
                if (totalPrice != 0) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrdersPage(),
                    ),
                  );
                }
              },
              child: const ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text('Składanie zamówienia'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
