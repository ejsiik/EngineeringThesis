import 'package:flutter/material.dart';
import 'package:mobile_app/service/chat/chat.dart';
import 'package:mobile_app/service/database/chat_data.dart';

import 'chat_page.dart';

class AdminChatScreen extends StatefulWidget {
  const AdminChatScreen({Key? key}) : super(key: key);

  @override
  State<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  final Chat chat = Chat();
  final ChatData chatData = ChatData();
  late Stream<List<Map<String, String>>> usersStream;
  String selectedUserId = ''; // Track the selected user ID

  @override
  void initState() {
    super.initState();
    usersStream = chatData.getAllUsers(); // Fetch the list of all users
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Display the list of users
          Expanded(
            child: StreamBuilder<List<Map<String, String>>>(
              stream: usersStream,
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (userSnapshot.hasError) {
                  return Text(userSnapshot.error.toString());
                } else if (!userSnapshot.hasData ||
                    userSnapshot.data!.isEmpty) {
                  return const Text('No users available.');
                } else {
                  List<Map<String, String>> users = userSnapshot.data!;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      String userId = users[index]['id']!;
                      String userEmail = users[index]['email']!;
                      return ListTile(
                        title: Text(userEmail),
                        onTap: () {
                          // Update the selected user ID
                          setState(() {
                            selectedUserId = userId;
                          });

                          // Navigate to the ChatPage with the selected user's information
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                receiverEmail: userEmail,
                                receiverId: userId,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
