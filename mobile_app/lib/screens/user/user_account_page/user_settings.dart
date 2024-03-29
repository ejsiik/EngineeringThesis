import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';
import 'package:mobile_app/constants/text_strings.dart';
import 'package:mobile_app/screens/login/login_page.dart';
import 'package:mobile_app/screens/utils.dart';
import 'package:mobile_app/service/authentication/auth.dart';
import 'package:mobile_app/service/database/chat_data.dart';
import 'package:mobile_app/service/database/order_data.dart';
import '../../../service/connection/connection_check.dart';
import '../../../service/database/data.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  TextEditingController _nameController = TextEditingController();
  String newName = '';

  void showSnackBarSimpleMessage(String message) {
    Utils.showSnackBarSimpleMessage(context, message);
  }

  void signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    const Color logoutColor = AppColors.logout;
    final Color buttonBackgroundColor = theme.brightness == Brightness.light
        ? AppColors.primaryLight
        : AppColors.primaryDark;
    final Color buttonTextColor = theme.brightness == Brightness.light
        ? AppColors.backgroundLight
        : AppColors.backgroundDark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ustawienia użytkownika'),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16.0),
              // TextField for changing username
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Zmień imię'),
                maxLength: 15,
                onChanged: (value) {
                  newName = value;
                },
              ),
              SizedBox(height: 16.0),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: buttonTextColor,
                  backgroundColor: buttonBackgroundColor,
                ),
                onPressed: () async {
                  bool isInternetConnected = await checkInternetConnectivity();
                  if (!isInternetConnected) {
                    showSnackBarSimpleMessage(connection);
                    return;
                  }
                  try {
                    if (newName.trim().isEmpty) {
                      showSnackBarSimpleMessage('Imię nie może być puste');
                      return;
                    }
                    if (newName.length > 15) {
                      showSnackBarSimpleMessage(
                          'Imię nie może być dłuższe niż 15 znaków');
                      return;
                    }
                    Data().changeUserName(newName);
                    _nameController.clear();
                    showSnackBarSimpleMessage('Imię zostało zmienione');
                  } catch (error) {
                    showSnackBarSimpleMessage('Błąd podczas zmiany imienia');
                  }
                },
                child: Text('Zmień imię'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: buttonTextColor,
                backgroundColor: buttonBackgroundColor,
              ),
              onPressed: () async {
                print("Before navigation");
                if (mounted) {
                  try {
                    // Use pushReplacement to navigate to the login page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  } catch (e) {
                    print("Error during navigation: $e");
                  }
                  print("After navigation");

                  // Show a Snackbar for successful deletion
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Zostałeś wylogowany'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  await Auth().signOut();
                  Navigator.pop(context);
                }
              },
              child: Text('WYLOGUJ SIĘ'),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                _showDeleteConfirmationDialog(context);
              },
              child: Text(
                'Usuń konto',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: logoutColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show the confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context) {
    // Store the context in a variable
    BuildContext dialogContext;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Assign the context to the variable
        dialogContext = context;

        return AlertDialog(
          title: Text('Usuń konto'),
          content: Text('Jesteś pewien, że chcesz usunąć konto?'),
          actions: [
            TextButton(
              onPressed: () {
                // User canceled the deletion
                Navigator.of(dialogContext).pop();
              },
              child: Text('Anuluj'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  bool isInternetConnected = await checkInternetConnectivity();
                  if (!isInternetConnected) {
                    showSnackBarSimpleMessage(connection);
                    return;
                  }
                  // Close the dialog using the stored context
                  Navigator.of(context).pop(); // Close the dialog
                  // Call an async function to handle deletion
                  await _handleDeletion(dialogContext);
                } catch (e) {
                  print("Error during alert: $e");
                }
              },
              child: Text(
                'Usuń',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // Separate async function to handle deletion
  Future<void> _handleDeletion(BuildContext context) async {
    try {
      // Close the confirmation dialog immediately
      Navigator.of(context).pop();
      await OrderData()
          .deleteUser(); // Delete user's orders from the Realtime Database
      await Data().deleteUser(); // Delete user from the Realtime Database
      await ChatData().deleteUser(); // Delete user from the Firestore Database
      await Auth().deleteUser(); // Delete user from Firebase Authentication

      print("Before navigation");
      if (mounted) {
        try {
          // Use pushReplacement to navigate to the login page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } catch (e) {
          print("Error during navigation: $e");
        }
        print("After navigation");

        // Show a Snackbar for successful deletion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Konto zostało usunięte'),
            duration: Duration(seconds: 2),
          ),
        );
        await Auth().signOut();
        Navigator.pop(context);
      }
    } catch (e) {
      print("Error during deletion: $e");
    }
  }
}
