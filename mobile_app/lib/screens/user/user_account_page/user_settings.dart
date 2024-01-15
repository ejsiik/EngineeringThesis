import 'package:flutter/material.dart';
import 'package:mobile_app/constants/text_strings.dart';
import 'package:mobile_app/screens/login/login_page.dart';
import 'package:mobile_app/service/authentication/auth.dart';
import 'package:mobile_app/service/database/chat_data.dart';
import 'package:mobile_app/service/database/order_data.dart';
import '../../../service/connection/connection_check.dart';
import '../../../service/database/data.dart';

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  TextEditingController _nameController = TextEditingController();
  String newName = '';

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ustawienia użytkownika'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TextField for changing username
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Zmień imię'),
              onChanged: (value) {
                newName = value;
              },
            ),
            SizedBox(height: 16.0),

            ElevatedButton(
              onPressed: () async {
                bool isInternetConnected = await checkInternetConnectivity();
                if (!isInternetConnected) {
                  _showSnackBar(connection);

                  return;
                }
                try {
                  Data().changeUserName(newName);
                  _nameController.clear(); // Clear the TextField
                  _showSnackBar('Imię zostało zmienione');
                } catch (error) {
                  _showSnackBar('Błąd podczas zmiany imienia');
                }
              },
              child: Text('Zmień imię'),
            ),

            // Delete account with GestureDetector and Text
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      // Show confirmation dialog before deleting account
                      _showDeleteConfirmationDialog(context);
                    },
                    child: Text(
                      'Usuń konto',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                    _showSnackBar(connection);
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
      await Auth().signOut(); // Log the user out

      print("Before navigation");
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
    } catch (e) {
      print("Error during deletion: $e");
    }
  }
}
