import 'package:flutter/material.dart';
import 'package:mobile_app/database/product_data.dart';
import 'package:mobile_app/database/user_data.dart';
import '../../../constants/colors.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobile_app/screens/user/category_products_page/product_details_page.dart';

class ProductSearchResult extends StatefulWidget {
  //final List<ProductSearchModel> displayList;
  final String value;

  const ProductSearchResult(this.value, {super.key});

  @override
  State<ProductSearchResult> createState() => _ProductSearchResultState();
}

class _ProductSearchResultState extends State<ProductSearchResult> {
  int len = 0;
  ProductData productData = ProductData();
  UserData userData = UserData();
  static const String routeName = '/productSearchResultPage';

  Future<List<Map<String, dynamic>>> getProductData() async {
    List<Map<String, dynamic>> data =
        await productData.getProductDataByName(widget.value);

    return data;
  }

  Future<Uint8List?> loadImage(String imageUrl) async {
    final ref = FirebaseStorage.instance.ref().child(imageUrl);
    final data = await ref.getData();

    return data;
  }

  @override
  void initState() {
    super.initState();

    productData.getProductDataByNameLength(widget.value).then((value) {
      setState(() {
        len = value;
      });
    });
  }

  Widget buildProductItem(Map product) {
    Future<void> addToShoppingCart(String productId) async {
      await userData.addToShoppingCart(productId);
    }

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
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
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
        trailing: GestureDetector(
          onTap: () {
            addToShoppingCart(product['id']);
          },
          child: const Icon(Icons.shopping_cart),
        ),
        onTap: () {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wyniki wyszukiwania'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Znaleziono produktów: $len',
                        style: TextStyle(
                          fontSize: 20,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Wyszukiwana fraza: ${widget.value}',
                        style: TextStyle(
                          fontSize: 20,
                          color: textColor,
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
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
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
      ),
    );
  }
}
