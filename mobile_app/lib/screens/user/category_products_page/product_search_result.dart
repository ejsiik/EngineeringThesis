import 'package:flutter/material.dart';
import 'package:mobile_app/constants/text_strings.dart';
import 'package:mobile_app/service/connection/connection_check.dart';
import 'package:mobile_app/service/database/product_data.dart';
import 'package:mobile_app/service/database/data.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mobile_app/constants/colors.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobile_app/screens/user/category_products_page/product_details_page.dart';

class ProductSearchResult extends StatefulWidget {
  final String value;

  const ProductSearchResult(this.value, {super.key});

  @override
  State<ProductSearchResult> createState() => _ProductSearchResultState();
}

class _ProductSearchResultState extends State<ProductSearchResult> {
  int len = 0;
  ProductData productData = ProductData();
  Data userData = Data();
  static const String routeName = '/productSearchResultPage';

  @override
  void initState() {
    super.initState();

    productData.getProductDataByNameLength(widget.value).then((value) {
      setState(() {
        len = value;
      });
    });
  }

  Future<void> addOrRemoveFromWishlist(String productId) async {
    if (!await checkInternetConnectivity()) {
      _showSnackBar(connection);
    } else {
      bool data = await userData.addOrRemoveFromWishlist(productId);
      showSnackBarWishList(data);
    }
  }

  Future<List<Map<String, dynamic>>> getProductData() async {
    if (!await checkInternetConnectivity()) {
      return [];
    }

    List<Map<String, dynamic>> data =
        await productData.getProductDataByName(widget.value);
    return data;
  }

  Future<bool> isProductInShoppingCart(id) async {
    bool data = await userData.isProductInShoppingCart(id);
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

  Future<void> addToShoppingCart(String productId) async {
    if (!await checkInternetConnectivity()) {
      _showSnackBar(connection);
    } else {
      await userData.addToShoppingCart(productId);
      int quantity = await userData.getQuantityOfShoppingCart(productId);
      showSnackBarShoppingCart(quantity);
    }
  }

  void showSnackBarShoppingCart(int quantity) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          children: [
            Row(
              children: [
                Text(
                  "Produkt został dodany do koszyka.",
                  style: TextStyle(fontSize: 14),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "Ilość produktu w koszyku: ",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '$quantity',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showSnackBarWishList(bool addOrRemove) {
    String message =
        addOrRemove ? ' z listy obserwowanych' : ' do listy obserwowanych';

    String boldText = addOrRemove ? 'Usunięto' : 'Dodano';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          children: [
            Row(
              children: [
                Text(
                  boldText,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  message,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Widget buildProductItem(Map product) {
    final ThemeData theme = Theme.of(context);
    final Color shimmerBaseColor = theme.brightness == Brightness.light
        ? AppColors.shimmerBaseColorLight
        : AppColors.shimmerBaseColorDark;
    final Color shimmerHighlightColor = theme.brightness == Brightness.light
        ? AppColors.shimmerHighlightColorLight
        : AppColors.shimmerHighlightColorDark;

    Map<String, dynamic> details =
        (product['details'] as Map<dynamic, dynamic>).cast<String, dynamic>();
    Map<String, dynamic> images =
        (product['images'] as Map<dynamic, dynamic>).cast<String, dynamic>();
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: FutureBuilder(
          future: loadImage(images['img_1']),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: shimmerBaseColor,
                highlightColor: shimmerHighlightColor,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.white,
                ),
              );
            } else if (snapshot.hasError) {
              return const Icon(Icons.error);
            } else if (snapshot.data == null) {
              return const Icon(Icons.error);
            } else {
              return Image.memory(
                snapshot.data!,
                width: 100,
                height: 100,
              );
            }
          },
        ),
        title: Text(product['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cena: ${product['price']} zł'),
          ],
        ),
        trailing: Column(
          children: [
            GestureDetector(
              onTap: () {
                addOrRemoveFromWishlist(product['id']);
              },
              child: Icon(
                Icons.favorite,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                addToShoppingCart(product['id']);
              },
              child: Icon(
                Icons.shopping_cart,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        onTap: () async {
          if (!await checkInternetConnectivity()) {
            _showSnackBar(connection);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsPage(
                    product['category_id'],
                    product['id'],
                    product['name'],
                    product['price'],
                    details,
                    images,
                    routeName),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color textColor = theme.brightness == Brightness.light
        ? AppColors.textLight
        : AppColors.textDark;
    final Color shimmerBaseColor = theme.brightness == Brightness.light
        ? AppColors.shimmerBaseColorLight
        : AppColors.shimmerBaseColorDark;
    final Color shimmerHighlightColor = theme.brightness == Brightness.light
        ? AppColors.shimmerHighlightColorLight
        : AppColors.shimmerHighlightColorDark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wyniki wyszukiwania'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Znaleziono produktów: $len',
                        style: TextStyle(
                          fontSize: 20,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Wyszukiwana fraza: ${widget.value}',
                        style: TextStyle(
                          fontSize: 20,
                          color: textColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          FutureBuilder<List>(
            future: getProductData(),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Shimmer.fromColors(
                      baseColor: shimmerBaseColor,
                      highlightColor: shimmerHighlightColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (index) => Container(
                            margin: EdgeInsets.all(15.0),
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 100,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              } else {
                List? productsList = snapshot.data;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return buildProductItem(productsList![index]);
                    },
                    childCount: productsList?.length ?? 0,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
