import 'package:flutter/material.dart';
import 'package:mobile_app/service/chat/chat.dart';
import 'package:mobile_app/service/database/chat_data.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/colors.dart';
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
    final ThemeData theme = Theme.of(context);
    final Color shimmerBaseColor = theme.brightness == Brightness.light
        ? AppColors.shimmerBaseColorLight
        : AppColors.shimmerBaseColorDark;
    final Color shimmerHighlightColor = theme.brightness == Brightness.light
        ? AppColors.shimmerHighlightColorLight
        : AppColors.shimmerHighlightColorDark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Czat'),
      ),
      body: Column(
        children: [
          // Display the list of users
          Expanded(
            child: StreamBuilder<List<Map<String, String>>>(
              stream: usersStream,
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer.fromColors(
                    baseColor: shimmerBaseColor,
                    highlightColor: shimmerHighlightColor,
                    child: ListView.builder(
                      itemCount:
                          5, // You can adjust the number of shimmer loading items
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Container(
                            width: 200.0,
                            height: 16.0,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  );
                } else if (userSnapshot.hasError) {
                  return Text(userSnapshot.error.toString());
                } else if (!userSnapshot.hasData ||
                    userSnapshot.data!.isEmpty) {
                  return const Text('Brak wiadomości.');
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
                              builder: (context) => AdminChatPage(
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
