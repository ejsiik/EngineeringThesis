import 'package:flutter/material.dart';
import 'package:mobile_app/screens/user/category_products_page/product_details_page.dart';
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
    List<Map<String, dynamic>> data = await orderData.getBoughtProducts();
    setState(() {
      boughtProducts = data;
    });
  }

  Future<Map<String, dynamic>> getProductDataById(String id) async {
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
    // Navigate to ProductDetailsPage with the obtained productData
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(
            categoryId, productId, name, price, details, images, routeName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                    onTap: () => navigateToProductDetails(
                      categoryId,
                      productId,
                      productName,
                      price,
                      details,
                      images,
                      routeName,
                    ),
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
