import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/constants/text_strings.dart';
import 'package:mobile_app/screens/utils.dart';
import 'package:mobile_app/service/connection/connection_check.dart';
import 'package:mobile_app/service/database/order_data.dart';
import 'package:mobile_app/screens/user/orders_page/orders_detailed_page.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constants/colors.dart';

class OrdersListPage extends StatefulWidget {
  final String type;

  const OrdersListPage({super.key, required this.type});

  @override
  State<OrdersListPage> createState() {
    return _OrdersListState();
  }
}

class _OrdersListState extends State<OrdersListPage> {
  late Future<List<Map<String, dynamic>>> orders;
  OrderData orderData = OrderData();

  @override
  void initState() {
    super.initState();

    orders = getOrdersData(widget.type);
  }

  Future<List<Map<String, dynamic>>> getOrdersData(String type) async {
    if (!await checkInternetConnectivity()) {
      return [];
    }
    return orderData.getOrderList(type);
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zamówienia'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerLoadingOrdersList();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Map<String, dynamic>> ordersList = snapshot.data ?? [];

            if (ordersList.length == 0) {
              return Container(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    "Brak zamówień",
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
                itemCount: ordersList.length,
                itemBuilder: (context, index) {
                  MapEntry<String, dynamic> orderEntry =
                      ordersList[index].entries.first;
                  final orderData = Map<String, dynamic>.from(
                      (orderEntry.value) as Map<Object?, Object?>);

                  String city = orderData['order']['city'];
                  String street = orderData['order']['street'];
                  String streetNumber = orderData['order']['street_number'];

                  String formattedDate = DateFormat('yyyy-MM-dd HH:mm')
                      .format(DateTime.parse(orderData['order']['order_date']));

                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: ListTile(
                      title: Text(
                        'Zamówienie #${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            'Data: $formattedDate',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                          Text(
                            'Cena całkowita: ${orderData['order']['total_price']} zł',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Adres: $city, $street $streetNumber',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Kod odbioru: ${orderData['order']['order_code']}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onTap: () async {
                        if (!await checkInternetConnectivity()) {
                          showSnackBarSimpleMessage(connection);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailsPage(
                                  order: orderData['order']['shopping_list']),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}

class ShimmerLoadingOrdersList extends StatelessWidget {
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
        itemCount: 4,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              title: Container(
                height: 18,
                color: Colors.white,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Container(
                    height: 14,
                    color: Colors.white,
                  ),
                  Container(
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
