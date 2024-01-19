import 'package:flutter/material.dart';
import 'package:mobile_app/constants/text_strings.dart';
import 'package:mobile_app/service/connection/connection_check.dart';
import 'package:mobile_app/service/database/order_data.dart';
import 'package:mobile_app/screens/user/category_products_page/product_details_page.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constants/colors.dart';

class OrderDetailsPage extends StatefulWidget {
  final List<Object?> order;

  const OrderDetailsPage({Key? key, required this.order});

  @override
  State<OrderDetailsPage> createState() {
    return _OrderDetailsPageState();
  }
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  Future<Map<dynamic, dynamic>> getProductData(String id) async {
    if (!await checkInternetConnectivity()) {
      return {};
    }
    OrderData orderData = OrderData();
    Map<dynamic, dynamic> data = await orderData.getProductData(id);
    return data;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zakupione produkty'),
      ),
      body: ListView.builder(
        itemCount: widget.order.length,
        itemBuilder: (context, index) {
          final product = Map<String, dynamic>.from(
              widget.order[index] as Map<Object?, Object?>);

          return FutureBuilder<Map<dynamic, dynamic>>(
            future: getProductData(product['product_id']),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ShimmerLoadingTile();
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
                    onTap: () async {
                      if (!await checkInternetConnectivity()) {
                        _showSnackBar(connection);
                      } else {
                        final details = Map<String, dynamic>.from(
                            productData['details'] as Map<Object?, Object?>);
                        final images = Map<String, dynamic>.from(
                            productData['images'] as Map<Object?, Object?>);
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

class ShimmerLoadingTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color shimmerBaseColor = theme.brightness == Brightness.light
        ? AppColors.shimmerBaseColorLight
        : AppColors.shimmerBaseColorDark;
    final Color shimmerHighlightColor = theme.brightness == Brightness.light
        ? AppColors.shimmerHighlightColorLight
        : AppColors.shimmerHighlightColorDark;
    return Column(
      children: List.generate(
        4,
        (index) => Shimmer.fromColors(
          baseColor: shimmerBaseColor,
          highlightColor: shimmerHighlightColor,
          child: ListTile(
            title: Container(
              height: 60,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
