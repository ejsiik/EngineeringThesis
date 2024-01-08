import 'package:flutter/material.dart';
import 'package:mobile_app/service/database/order_data.dart';
import 'package:mobile_app/service/database/shop_location_data.dart';
import 'package:mobile_app/service/database/data.dart';
import 'package:mobile_app/screens/user/main_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() {
    return _OrdersState();
  }
}

class _OrdersState extends State<OrdersPage> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  late List shops = [];
  late List<bool> shopsExpansionStates = [];
  late Map<String, dynamic>? selectedLocationData = {};
  ShopLocationData shopLocationData = ShopLocationData();
  Data userData = Data();
  OrderData orderData = OrderData();
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    // Set up a listener for changes in the database
    getLocations();
  }

  Future<void> getLocations() async {
    shops = await shopLocationData.getAllShopsLocations();
    shopsExpansionStates = List<bool>.filled(shops.length, false);
    setState(() {});
  }

  Future<double> getTotalPrice() async {
    double totalPrice = await userData.getTotalPriceData();
    return totalPrice;
  }

  Future<void> addOrder(String name, String surname, String phone,
      Map<String, dynamic> location, double totalPrice) async {
    await orderData.addOrder(name, surname, phone, location, totalPrice);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Składanie zamówienia'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Imię',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Wprowadź imię',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nazwisko',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _surnameController,
                  decoration: const InputDecoration(
                    hintText: 'Wprowadź nazwisko',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Numer telefonu)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(
                    hintText: 'Wprowadź numer telefonu',
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Text(
                      'Wybierz lokalizację sklepu:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
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
                          if (shopsExpansionStates[i]) {
                            // Zapisz locationData po kliknięciu rozwijanej listy
                            selectedLocationData = Map<String, dynamic>.from(
                                shops[index]['location']
                                    as Map<Object?, Object?>);
                          }
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
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return ListTile(
                              title: Text(
                                  '${locationData['city']}, ${locationData['street']} ${locationData['street_number']}'),
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
                          headerBuilder:
                              (BuildContext context, bool isExpanded) =>
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
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<double>(
                future: getTotalPrice(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    totalPrice = snapshot.data ?? 0.0;
                    return Text(
                      'Cena całkowita: $totalPrice zł',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.orange,
            child: GestureDetector(
              onTap: () {
                if (_nameController.text.isNotEmpty &&
                    _surnameController.text.isNotEmpty &&
                    _phoneNumberController.text.isNotEmpty &&
                    selectedLocationData!.isNotEmpty &&
                    totalPrice != 0.0) {
                  addOrder(
                      _nameController.text.toString(),
                      _surnameController.text.toString(),
                      _phoneNumberController.text.toString(),
                      selectedLocationData!,
                      totalPrice);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainPage(),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Brak wymaganych danych'),
                        content: const Text(
                            'Wypełnij wszystkie pola przed złożeniem zamówienia.'),
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
              },
              child: const ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text('Złóż zamówienie'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
