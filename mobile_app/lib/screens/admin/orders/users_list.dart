import 'package:flutter/material.dart';
import 'package:mobile_app/screens/admin/orders/admin_orders.dart';
import 'package:mobile_app/service/database/order_data.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() {
    return _UsersListState();
  }
}

class _UsersListState extends State<UsersList> {
  OrderData orderData = OrderData();
  late Future<Map<String, String>> usersData;

  @override
  void initState() {
    super.initState();
    usersData = getUsersId();
  }

  Future<Map<String, String>> getUsersId() async {
    Map<String, String> data = await orderData.getUsersId();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zamówienia'),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: usersData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                String userId = snapshot.data!.keys.elementAt(index);
                String username = snapshot.data![userId]!;

                return Card(
                  elevation: 3,
                  margin: EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminOrders(id: userId),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(username),
                      leading: Icon(Icons.person),
                      trailing: Icon(Icons.arrow_forward),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
