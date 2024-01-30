import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';
import 'package:mobile_app/constants/text_strings.dart';
import 'package:mobile_app/screens/utils.dart';
import 'package:mobile_app/service/connection/connection_check.dart';
import 'package:mobile_app/service/database/order_data.dart';
import 'package:mobile_app/service/database/shop_location_data.dart';
import 'package:mobile_app/service/database/data.dart';
import 'package:mobile_app/screens/user/main_page.dart';
import 'package:shimmer/shimmer.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() {
    return _OrdersState();
  }
}

class _OrdersState extends State<OrdersPage> {
  late List shops = [];
  late List<bool> shopsExpansionStates = [];
  late List<bool> shopsCheckedStates = [];
  late Map<String, dynamic>? selectedLocationData = {};
  ShopLocationData shopLocationData = ShopLocationData();
  Data userData = Data();
  OrderData orderData = OrderData();
  double price = 0.0;
  String name = "";

  @override
  void initState() {
    super.initState();

    getLocations();
  }

  Future<String> getUserName() async {
    try {
      if (!await checkInternetConnectivity()) {
        return "";
      }
      String? userName = await userData.getUserName();
      return userName ?? '';
    } catch (error) {
      return 'Nieznany użytkownik';
    }
  }

  Future<void> getLocations() async {
    if (!await checkInternetConnectivity()) {
      shops = [];
      shopsExpansionStates = [];
      shopsCheckedStates = [];
    } else {
      shops = await shopLocationData.getAllShopsLocations();
      shopsExpansionStates = List<bool>.filled(shops.length, false);
      shopsCheckedStates = List<bool>.filled(shops.length, false);
      setState(() {});
    }
  }

  Future<double> getTotalPrice() async {
    if (!await checkInternetConnectivity()) {
      return 0.0;
    } else {
      double price = await userData.getTotalPriceData();
      return price;
    }
  }

  Future<void> addOrder(
      String name, Map<String, dynamic> location, double totalPrice) async {
    await orderData.addOrder(name, location, totalPrice);
  }

  void showSnackBarSimpleMessage(String message) {
    Utils.showSnackBarSimpleMessage(context, message);
  }

  Widget buildDay(String day, Map<dynamic, dynamic> dayData) {
    String openTime = dayData['open']!.toString();
    String closedTime = dayData['closed']!.toString();
    String hours = "";

    if (openTime.isEmpty || closedTime.isEmpty) {
      hours = "nieczynne";
    } else {
      hours = "$openTime - $closedTime";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            hours,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color primaryColor = theme.brightness == Brightness.light
        ? AppColors.primaryLight
        : AppColors.primaryDark;
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
        title: const Text('Składanie zamówienia'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<double>(
              future: userData.getTotalPriceData(),
              builder: (BuildContext context,
                  AsyncSnapshot<double> totalPriceSnapshot) {
                if (totalPriceSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return ShimmerLoadingTotalPrice();
                } else if (totalPriceSnapshot.hasError) {
                  return Text('Error: ${totalPriceSnapshot.error}');
                } else {
                  double totalPrice = totalPriceSnapshot.data ?? 0.0;
                  price = totalPrice;
                  return Container(
                    padding: EdgeInsets.all(12.0),
                    color: Colors.grey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Wartość zamówienia: $totalPrice zł',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            FutureBuilder<String>(
              future: getUserName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer.fromColors(
                    baseColor: shimmerBaseColor,
                    highlightColor: shimmerHighlightColor,
                    child: Container(
                        width: double.infinity,
                        height: 60.0,
                        color: backgroundColor),
                  );
                } else {
                  String userName = snapshot.data ?? 'Nieznany użytkownik';
                  name = userName;
                  TextEditingController usernameController =
                      TextEditingController(text: '$userName');

                  return TextField(
                    controller: usernameController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Twoja nazwa:',
                      labelStyle: TextStyle(
                        fontSize: 20,
                        color: textColor,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Wybierz lokalizację sklepu:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ExpansionPanelList(
              expandedHeaderPadding: const EdgeInsets.all(0),
              elevation: 1,
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  for (var i = 0; i < shopsExpansionStates.length; i++) {
                    if (i != index) {
                      shopsExpansionStates[i] = false;
                    } else {
                      shopsExpansionStates[i] = !shopsExpansionStates[i];
                    }
                  }
                });
              },
              children: shops.asMap().entries.map<ExpansionPanel>(
                (entry) {
                  var item = entry.value;
                  var index = entry.key;
                  var daysData = item['days'];
                  var locationData = item['location'];
                  if (daysData is Map && locationData is Map) {
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          leading: Checkbox(
                            value: shopsCheckedStates[index],
                            onChanged: (bool? value) {
                              setState(() {
                                for (var i = 0;
                                    i < shopsCheckedStates.length;
                                    i++) {
                                  if (i != index) {
                                    shopsCheckedStates[i] = false;
                                  } else {
                                    shopsCheckedStates[i] =
                                        !shopsCheckedStates[i];
                                    selectedLocationData = {};
                                    if (shopsCheckedStates[i]) {
                                      selectedLocationData =
                                          Map<String, dynamic>.from(shops[index]
                                                  ['location']
                                              as Map<Object?, Object?>);
                                    }
                                  }
                                }
                              });
                            },
                          ),
                          title: Text(
                            '${locationData['city']}, ${locationData['street']} ${locationData['street_number']}',
                          ),
                        );
                      },
                      body: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildDay('Poniedziałek:', daysData['monday']),
                            buildDay('Wtorek:', daysData['tuesday']),
                            buildDay('Środa:', daysData['wednesday']!),
                            buildDay('Czwartek:', daysData['thursday']!),
                            buildDay('Piątek:', daysData['friday']!),
                            buildDay('Sobota:', daysData['saturday']!),
                            buildDay('Niedziela:', daysData['sunday']!),
                          ],
                        ),
                      ),
                      isExpanded: shopsExpansionStates[index],
                    );
                  } else {
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) =>
                          const ListTile(title: Text('Invalid Data')),
                      body: const ListTile(title: Text('Invalid Data')),
                      isExpanded: true,
                    );
                  }
                },
              ).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: primaryColor,
        child: GestureDetector(
          onTap: () async {
            if (!await checkInternetConnectivity()) {
              showSnackBarSimpleMessage(connection);
            } else {
              if (name.isNotEmpty &&
                  selectedLocationData!.isNotEmpty &&
                  price != 0.0) {
                addOrder(name, selectedLocationData!, price);

                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: MaterialLocalizations.of(context)
                      .modalBarrierDismissLabel,
                  barrierColor: Colors.black.withOpacity(0.5),
                  transitionDuration: const Duration(milliseconds: 200),
                  pageBuilder: (BuildContext buildContext, Animation animation,
                      Animation secondaryAnimation) {
                    return Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Twoje zamówienie zostało złożone",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              "Dziękujemy",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    );
                  },
                );
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainPage(),
                    ),
                    (route) => false,
                  );
                });
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Brak wymaganych danych'),
                      content: const Text(
                          'Przed złożeniem zamówienia wybierz lokalizację sklepu.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            }
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
                'Złóż zamówienie',
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
    );
  }
}

class ShimmerLoadingTotalPrice extends StatelessWidget {
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
        width: 600,
        height: 47,
        color: Colors.white,
      ),
    );
  }
}
