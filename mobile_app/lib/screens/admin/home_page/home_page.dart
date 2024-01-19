import 'package:flutter/material.dart';
import 'package:mobile_app/screens/admin/home_page/qr_button.dart';
import 'package:mobile_app/screens/admin/orders/search_order.dart';
import '../../../constants/text_strings.dart';
import '../../../service/authentication/auth.dart';
import '../../../constants/colors.dart';
import '../../../service/connection/connection_check.dart';
import 'entry_field.dart';
import 'submit_button.dart';
import 'error_message.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  String? errorMessage = '';
  bool _welcomeBanner = false;

  final TextEditingController _controllerUserID = TextEditingController();
  final TextEditingController _controllerValue = TextEditingController();
  final TextEditingController _orderCodeController = TextEditingController();

  Widget _buildSubmitButton() {
    return SubmitButton(
      controllerUserID: _controllerUserID,
      controllerValue: _controllerValue,
      welcomeBanner: _welcomeBanner,
      onSubmitted: (message) {
        setState(() {
          errorMessage = message;
        });
      },
    );
  }

  void _scanQRCode(String result) {
    setState(() {
      _controllerUserID.text = result;
    });
  }

  void signOut() async {
    bool isInternetConnected = await checkInternetConnectivity();
    if (!isInternetConnected) {
      setState(() {
        errorMessage = connection;
      });
      return;
    }
    await Auth().signOut();
  }

  void updateOrderCode(String value) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (contex) => SearchOrder(orderCode: value)),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Widget _buildWelcomeBannerCheckbox() {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color primaryColor = theme.brightness == Brightness.light
        ? AppColors.primaryLight
        : AppColors.primaryDark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: _welcomeBanner,
          onChanged: (value) {
            setState(() {
              _welcomeBanner = value!;
              if (_welcomeBanner) {
                _controllerValue.clear();
              }
            });
          },
          activeColor: primaryColor,
          checkColor: backgroundColor,
        ),
        Text(
          'Kupon powitalny',
          style: TextStyle(color: primaryColor),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color logoutColor = theme.brightness == Brightness.light
        ? AppColors.primaryLight
        : AppColors.primaryDark;
    final Color primaryColor = theme.brightness == Brightness.light
        ? AppColors.primaryLight
        : AppColors.primaryDark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Text(
            'Shop X',
            style: TextStyle(color: primaryColor),
          ),
          actions: [
            IconButton(
              onPressed: signOut,
              icon: Icon(Icons.logout, color: logoutColor),
            ),
          ],
        ),
        body: Container(
          color: backgroundColor,
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    QRButton(onScan: _scanQRCode),
                  ],
                ),
                EntryField(
                  title: 'ID Użytkownika',
                  controller: _controllerUserID,
                  prefixIcon: Icons.person,
                  welcomeBanner: _welcomeBanner,
                  onValueChanged: (value) {
                    setState(() {
                      _welcomeBanner = value == 'true';
                      if (_welcomeBanner) {
                        _controllerValue.clear();
                      }
                    });
                  },
                ),
                const SizedBox(height: 10),
                EntryField(
                  title: 'Wartość',
                  controller: _controllerValue,
                  prefixIcon: Icons.money,
                  welcomeBanner: _welcomeBanner,
                  onValueChanged: (value) {
                    setState(() {
                      _welcomeBanner = value == 'true';
                      if (_welcomeBanner) {
                        _controllerValue.clear();
                      }
                    });
                  },
                ),
                _buildWelcomeBannerCheckbox(),
                const SizedBox(height: 30),
                ErrorMessage(message: errorMessage as String),
                _buildSubmitButton(),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: _orderCodeController,
                    onSubmitted: (value) async {
                      _orderCodeController.clear();
                      if (!await checkInternetConnectivity()) {
                        _showSnackBar(connection);
                      } else {
                        updateOrderCode(value);
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Wprowadź kod odbioru",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () async {
                          String searchValue = _orderCodeController.text;
                          _orderCodeController.clear();
                          if (!await checkInternetConnectivity()) {
                            _showSnackBar(connection);
                          } else {
                            updateOrderCode(searchValue);
                          }
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
