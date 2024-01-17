import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/service/connection/connection_check.dart';
import 'package:mobile_app/service/database/data.dart';
import 'package:mobile_app/screens/user/category_products_page/product_details_page.dart';
import 'package:mobile_app/screens/user/orders_page/orders_page.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/colors.dart';

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

  @override
  void initState() {
    super.initState();
    getTotalPrice();
  }

  Future<double> getTotalPrice() async {
    double totalPriceData = await userData.getTotalPriceData();
    return totalPriceData;
  }

  Future<List<dynamic>> getShoppingCartData() async {
    if (!await checkInternetConnectivity()) {
      return [];
    }

    List<dynamic> data = await userData.getShoppingCartData();
    return data;
  }

  Future<Uint8List?> loadImage(String imageUrl) async {
    if (!await checkInternetConnectivity()) {
      return null;
    }

    final ref = FirebaseStorage.instance.ref().child(imageUrl);
    final data = await ref.getData();
    return data;
  }

  Widget buildProductItem(Map productMap) {
    Future<void> removeFromShoppingCart(String productId) async {
      await userData.removeFromShoppingCart(productId);

      setState(() {});
    }

    Future<void> changeQuantityInShoppingCart(
        String productId, int quantity) async {
      await userData.changeQuantityInShoppingCart(productId, quantity);
    }

    Future<int> getQuantityOfShoppingCart(String productId) async {
      if (!await checkInternetConnectivity()) {
        return 0;
      }

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
              return ShimmerLoadingProductImage();
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
                      return ShimmerLoadingQuantity();
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
                  return ShimmerLoadingQuantity();
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
            removeFromShoppingCart(productMap['id']);
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
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.brightness == Brightness.light
        ? AppColors.primaryLight
        : AppColors.primaryDark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Koszyk'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<double>(
        future: getTotalPrice(),
        builder:
            (BuildContext context, AsyncSnapshot<double> totalPriceSnapshot) {
          if (totalPriceSnapshot.connectionState == ConnectionState.waiting) {
            return ShimmerLoadingShoppingCart();
          } else if (totalPriceSnapshot.hasError) {
            return Text('Error: ${totalPriceSnapshot.error}');
          } else {
            double totalPrice = totalPriceSnapshot.data ?? 0.0;

            return Column(
              children: [
                if (totalPrice > 0)
                  Container(
                    padding: EdgeInsets.all(12.0),
                    color: Colors.grey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Wartość całkowita: ${totalPrice.toStringAsFixed(2)} zł',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: FutureBuilder<List>(
                    future: getShoppingCartData(),
                    builder:
                        (BuildContext context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ShimmerLoadingShoppingCart();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List? productsList = snapshot.data;
                        if (productsList?.length == 0) {
                          return Container(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                "Twój koszyk jest pusty",
                                style: TextStyle(
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: productsList?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return buildProductItem(productsList![index]);
                            },
                          );
                        }
                      }
                    },
                  ),
                ),
                if (totalPrice > 0)
                  Container(
                    padding: EdgeInsets.all(16.0),
                    color: Colors.orange,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrdersPage(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Składanie zamówienia',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}

class ShimmerLoadingQuantity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color shimmerBaseColor = theme.brightness == Brightness.light
        ? AppColors.shimmerBaseColorLight
        : AppColors.shimmerBaseColorDark;
    final Color shimmerHighlightColor = theme.brightness == Brightness.light
        ? AppColors.shimmerHighlightColorLight
        : AppColors.shimmerHighlightColorDark;
    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: Container(
        width: 40,
        height: 24,
        color: Colors.white,
      ),
    );
  }
}

class ShimmerLoadingProductImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color shimmerBaseColor = theme.brightness == Brightness.light
        ? AppColors.shimmerBaseColorLight
        : AppColors.shimmerBaseColorDark;
    final Color shimmerHighlightColor = theme.brightness == Brightness.light
        ? AppColors.shimmerHighlightColorLight
        : AppColors.shimmerHighlightColorDark;
    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: Container(
        width: 80,
        height: 80,
        color: Colors.white,
      ),
    );
  }
}

class ShimmerLoadingShoppingCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color shimmerBaseColor = theme.brightness == Brightness.light
        ? AppColors.shimmerBaseColorLight
        : AppColors.shimmerBaseColorDark;
    final Color shimmerHighlightColor = theme.brightness == Brightness.light
        ? AppColors.shimmerHighlightColorLight
        : AppColors.shimmerHighlightColorDark;
    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Container(
                height: 18,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
