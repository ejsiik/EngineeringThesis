import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/constants/text_strings.dart';
import 'package:mobile_app/constants/colors.dart';
import 'package:mobile_app/screens/utils.dart';
import 'package:mobile_app/service/connection/connection_check.dart';
import 'package:mobile_app/service/database/product_data.dart';
import 'package:mobile_app/service/database/data.dart';
import 'package:mobile_app/screens/user/category_products_page/product_details_page.dart';
import 'package:shimmer/shimmer.dart';

class CategoryProductsPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const CategoryProductsPage(this.categoryId, this.categoryName, {super.key});

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  ProductData productData = ProductData();
  Data userData = Data();
  late bool _isMounted;
  static const String routeName = '/categoryProductsPage';

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isMounted) {
      getProductData();
    }
  }

  Future<void> addOrRemoveFromWishlist(String productId) async {
    bool data = await userData.addOrRemoveFromWishlist(productId);
    showSnackBarWishList(data);
  }

  Future<List<Map<String, dynamic>>> getProductData() async {
    if (!await checkInternetConnectivity()) {
      showSnackBarSimpleMessage(connection);
      return [];
    }

    List<Map<String, dynamic>> data =
        await productData.getProductData(widget.categoryId);
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
    await userData.addToShoppingCart(productId);
    showSnackBarShoppingCart(true);
  }

  Future<void> removeFromShoppingCart(String productId) async {
    await userData.removeFromShoppingCart(productId);
    showSnackBarShoppingCart(false);
  }

  Future<bool> isProductInShoppingCart(id) async {
    bool data = await userData.isProductInShoppingCart(id);
    return data;
  }

  Future<bool> isProductInWishlist(id) async {
    bool data = await userData.isProductInWishlist(id);
    return data;
  }

  void showSnackBarSimpleMessage(String message) {
    Utils.showSnackBarSimpleMessage(context, message);
  }

  void showSnackBarShoppingCart(bool isInShoppingCart) {
    Utils.showSnackBarShoppingCart(context, isInShoppingCart);
  }

  void showSnackBarWishList(bool addOrRemove) async {
    Utils.showSnackBarWishList(context, addOrRemove);
  }

  Widget buildProductItem(Map product) {
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
              return ShimmerLoadingProductImage();
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
            FutureBuilder<bool>(
              future: userData.isProductInWishlist(product['id']),
              builder: (context, wishlistSnapshot) {
                if (wishlistSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Container(
                    child: Icon(
                      Icons.favorite,
                      color: Colors.grey,
                    ),
                  );
                } else if (wishlistSnapshot.hasError) {
                  return Icon(Icons.error, color: Colors.red);
                } else {
                  bool isProductInWishlist = wishlistSnapshot.data ?? false;

                  return GestureDetector(
                    onTap: () async {
                      if (!await checkInternetConnectivity()) {
                        showSnackBarSimpleMessage(connection);
                      } else {
                        await addOrRemoveFromWishlist(product['id']);
                        setState(() {});
                      }
                    },
                    child: Icon(
                      Icons.favorite,
                      color: isProductInWishlist ? Colors.red : Colors.grey,
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 8),
            FutureBuilder<bool>(
              future: userData.isProductInShoppingCart(product['id']),
              builder: (context, cartSnapshot) {
                if (cartSnapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.grey,
                    ),
                  );
                } else if (cartSnapshot.hasError) {
                  return Icon(Icons.error, color: Colors.red);
                } else {
                  bool isProductInCart = cartSnapshot.data ?? false;

                  return GestureDetector(
                    onTap: () async {
                      if (!await checkInternetConnectivity()) {
                        showSnackBarSimpleMessage(connection);
                      } else {
                        if (isProductInCart) {
                          await removeFromShoppingCart(product['id']);
                        } else {
                          await addToShoppingCart(product['id']);
                        }
                        setState(() {});
                      }
                    },
                    child: Icon(
                      Icons.shopping_cart,
                      color: isProductInCart ? Colors.green : Colors.grey,
                    ),
                  );
                }
              },
            ),
          ],
        ),
        onTap: () async {
          if (!await checkInternetConnectivity()) {
            showSnackBarSimpleMessage(connection);
          } else {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsPage(
                    widget.categoryId,
                    product['id'],
                    product['name'],
                    product['price'],
                    details,
                    images,
                    routeName),
              ),
            );
            setState(() {});
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produkty w kategorii ${widget.categoryName}'),
      ),
      body: FutureBuilder<List>(
        future: getProductData(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerLoadingProducts();
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
        width: 100,
        height: 100,
        color: Colors.white,
      ),
    );
  }
}

class ShimmerLoadingProducts extends StatelessWidget {
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
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: Container(
                width: 100,
                height: 100,
                color: Colors.white,
              ),
              title: Container(
                width: 150,
                height: 16,
                color: Colors.white,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 16,
                    color: Colors.white,
                  ),
                ],
              ),
              trailing: Container(
                width: 24,
                height: 24,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
