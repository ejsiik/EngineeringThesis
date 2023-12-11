import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/service/chat/chat.dart';
import 'package:mobile_app/service/authentication/auth.dart';
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
          // Display the messages for the selected user
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chat.getMessages(Auth().userId(), selectedUserId),
              builder: (context, snapshot) {
                try {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No messages available for admin.');
                  } else {
                    var messages = snapshot.data!.docs.reversed;
                    List<Widget> messageWidgets = [];

                    for (var message in messages) {
                      var messageData = message.data() as Map<String, dynamic>;
                      var messageText = messageData['message'];
                      var messageSender = messageData['senderEmail'];

                      var messageWidget =
                          MessageWidget(messageSender, messageText);
                      messageWidgets.add(messageWidget);
                    }

                    return ListView(
                      reverse: true,
                      children: messageWidgets,
                    );
                  }
                } catch (error) {
                  return const Text('An error occurred (caught)');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String sender;
  final String text;

  const MessageWidget(this.sender, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '$sender: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(text),
        ],
      ),
    );
  }
}
