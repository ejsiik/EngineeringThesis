import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';
import 'package:mobile_app/constants/text_strings.dart';
import 'package:mobile_app/screens/user/category_products_page/product_details_page.dart';
import 'package:mobile_app/service/connection/connection_check.dart';
import 'package:mobile_app/service/database/order_data.dart';
import 'package:mobile_app/service/database/product_data.dart';

class PurchasedProductsPage extends StatefulWidget {
  const PurchasedProductsPage({Key? key}) : super(key: key);

  @override
  State<PurchasedProductsPage> createState() {
    return _PurchasedProductsPageState();
  }
}

class _PurchasedProductsPageState extends State<PurchasedProductsPage> {
  OrderData orderData = OrderData();
  ProductData productData = ProductData();
  late List<Map<String, dynamic>> boughtProducts = [];

  @override
  void initState() {
    super.initState();

    getBoughtProducts();
  }

  Future<void> getBoughtProducts() async {
    if (!await checkInternetConnectivity()) {
      boughtProducts = [];
    } else {
      List<Map<String, dynamic>> data = await orderData.getBoughtProducts();
      setState(() {
        boughtProducts = data;
      });
    }
  }

  Future<Map<String, dynamic>> getProductDataById(String id) async {
    if (!await checkInternetConnectivity()) {
      return {};
    }

    Map<String, dynamic> data = await productData.getProductDataById(id);
    return data;
  }

  Future<void> navigateToProductDetails(
      int categoryId,
      String productId,
      String name,
      int price,
      Map<String, dynamic> details,
      Map<String, dynamic> images,
      String routeName) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(
            categoryId, productId, name, price, details, images, routeName),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.brightness == Brightness.light
        ? AppColors.primaryLight
        : AppColors.primaryDark;

    if (boughtProducts.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Zakupione produkty'),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              "Brak produktów",
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Zakupione produkty'),
        ),
        body: ListView.builder(
          itemCount: boughtProducts.length,
          itemBuilder: (context, index) {
            String productId = boughtProducts[index].keys.first;
            int quantity = boughtProducts[index][productId]['quantity'];

            return FutureBuilder<Map<String, dynamic>>(
              future: getProductDataById(productId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return ListTile(
                    title: Text('Error loading product data'),
                  );
                } else {
                  Map<String, dynamic> productData = snapshot.data!;
                  int categoryId = productData['category_id'];
                  String productName = productData['name'];
                  int price = productData['price'];
                  String routeName = "/purchasedProducts";

                  Map<String, dynamic> details =
                      (productData['details'] as Map<dynamic, dynamic>)
                          .cast<String, dynamic>();
                  Map<String, dynamic> images =
                      (productData['images'] as Map<dynamic, dynamic>)
                          .cast<String, dynamic>();

                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: ListTile(
                      title: RichText(
                        text: TextSpan(
                          text: 'Nazwa produktu: ',
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text: productName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      subtitle: RichText(
                        text: TextSpan(
                          text: 'Ilość: ',
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text: quantity.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        if (!await checkInternetConnectivity()) {
                          _showSnackBar(connection);
                        } else {
                          navigateToProductDetails(
                            categoryId,
                            productId,
                            productName,
                            price,
                            details,
                            images,
                            routeName,
                          );
                        }
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
}
