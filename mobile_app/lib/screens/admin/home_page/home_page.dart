import 'package:flutter/material.dart';
import 'package:mobile_app/screens/admin/home_page/qr_button.dart';
import '../../../service/authentication/auth.dart';
import '../../../constants/colors.dart';
import '../chat/admin_chat.dart';
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
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    const Color logoutColor = AppColors.logout;
    final Color primaryColor = theme.brightness == Brightness.light
        ? AppColors.primaryLight
        : AppColors.primaryDark;
    final Color navbarSelectedColor = theme.brightness == Brightness.light
        ? AppColors.navbarSelectedLight
        : AppColors.navbarSelectedDark;
    final Color navbarUnselectedColor = theme.brightness == Brightness.light
        ? AppColors.navbarUnselectedLight
        : AppColors.navbarUnselectedDark;
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
              icon: const Icon(Icons.logout, color: logoutColor),
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
                  activeColor: navbarSelectedColor,
                  checkColor: navbarUnselectedColor,
                  fillColor: MaterialStateColor.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return primaryColor;
                    }
                    return primaryColor;
                  }),
                ),
                Text(
                  'Kupon powitalny',
                  style: TextStyle(color: primaryColor),
                ),
                const SizedBox(height: 30),
                ErrorMessage(message: errorMessage as String),
                _buildSubmitButton(),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminChatScreen()),
                    );
                  },
                  child: const Text('Idź do czatu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
