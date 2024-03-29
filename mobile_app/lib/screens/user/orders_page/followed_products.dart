import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';
import 'package:mobile_app/constants/text_strings.dart';
import 'package:mobile_app/screens/user/category_products_page/product_details_page.dart';
import 'package:mobile_app/screens/utils.dart';
import 'package:mobile_app/service/connection/connection_check.dart';
import 'package:mobile_app/service/database/data.dart';
import 'package:mobile_app/service/database/product_data.dart';

class FollowedProductsPage extends StatefulWidget {
  const FollowedProductsPage({Key? key}) : super(key: key);

  @override
  State<FollowedProductsPage> createState() {
    return _FollowedProductsPageState();
  }
}

class _FollowedProductsPageState extends State<FollowedProductsPage> {
  ProductData productData = ProductData();
  Data userData = Data();
  late bool _isMounted;
  late List<dynamic> followedProducts = [];
  late bool isDataFetched = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    getWishlistData();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> getWishlistData() async {
    if (!await checkInternetConnectivity()) {
      followedProducts = [];
    } else {
      List<dynamic> data = await userData.getWishlistData();
      if (_isMounted) {
        setState(() {
          followedProducts = data;
          isDataFetched = true;
        });
      }
    }
  }

  Future<void> addOrRemoveFromWishlist(String productId) async {
    bool data = await userData.addOrRemoveFromWishlist(productId);
    showSnackBarWishList(data);
    getWishlistData();
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
    String routeName,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(
          categoryId,
          productId,
          name,
          price,
          details,
          images,
          routeName,
        ),
      ),
    );

    getWishlistData();
  }

  void showSnackBarWishList(bool addOrRemove) {
    Utils.showSnackBarWishList(context, addOrRemove);
  }

  void showSnackBarSimpleMessage(String message) {
    Utils.showSnackBarSimpleMessage(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.brightness == Brightness.light
        ? AppColors.primaryLight
        : AppColors.primaryDark;

    if (isDataFetched && followedProducts.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Obserwowane produkty'),
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
          title: const Text('Obserwowane produkty'),
        ),
        body: ListView.builder(
          itemCount: followedProducts.length,
          itemBuilder: (context, index) {
            String productId = followedProducts[index]['product_id'];

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
                  String routeName = "/followedProducts";

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
                          text: 'Cena: ',
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text: '${price} zł',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: GestureDetector(
                        onTap: () async {
                          if (!await checkInternetConnectivity()) {
                            showSnackBarSimpleMessage(connection);
                          } else {
                            addOrRemoveFromWishlist(productId);
                          }
                        },
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      ),
                      onTap: () async {
                        if (!await checkInternetConnectivity()) {
                          showSnackBarSimpleMessage(connection);
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
