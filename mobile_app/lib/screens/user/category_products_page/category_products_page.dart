import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/service/database/product_data.dart';
import 'package:mobile_app/service/database/data.dart';
import 'package:mobile_app/screens/user/category_products_page/product_details_page.dart';

class CategoryProductsPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const CategoryProductsPage(this.categoryId, this.categoryName, {super.key});

  @override
  State<CategoryProductsPage> createState() {
    return _CategoryProductsPageState();
  }
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  ProductData productData = ProductData();
  Data userData = Data();
  static const String routeName = '/categoryProductsPage';

  Future<List<Map<String, dynamic>>> getProductData() async {
    List<Map<String, dynamic>> data =
        await productData.getProductData(widget.categoryId);

    return data;
  }

  Future<Uint8List?> loadImage(String imageUrl) async {
    final ref = FirebaseStorage.instance.ref().child(imageUrl);
    final data = await ref.getData();
    return data;
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
                  widget.categoryId,
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Produkty w kategorii ${widget.categoryName}'),
      ),
      body: FutureBuilder<List>(
        future: getProductData(),
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
    );
  }
}
