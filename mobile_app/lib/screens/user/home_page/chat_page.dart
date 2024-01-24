import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/service/authentication/auth.dart';
import 'package:mobile_app/service/chat/chat.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/colors.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;

  const ChatPage({
    Key? key,
    required this.receiverEmail,
    required this.receiverId,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final Auth auth = Auth();
  late Chat chat;

  @override
  void initState() {
    super.initState();
    chat = Chat(auth: auth);
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await Chat(auth: auth)
          .sendMessage(widget.receiverId, messageController.text);
      messageController.clear();
    }
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
        title: const Text('Czatuj ze sklepem'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: chat.getMessages(Auth().userId(), widget.receiverId),
                builder: (context, snapshot) {
                  try {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListView.builder(
                        reverse: true,
                        itemCount: 8, // Number of shimmer placeholders
                        itemBuilder: (context, index) {
                          final isMyMessage = index % 2 ==
                              0; // Alternate between left and right

                          return Shimmer.fromColors(
                            baseColor: shimmerBaseColor,
                            highlightColor: shimmerHighlightColor,
                            child: ListTile(
                              title: Container(
                                height: 20.0,
                                width: isMyMessage
                                    ? 100.0
                                    : 150.0, // Customize width based on message direction
                                margin: isMyMessage
                                    ? EdgeInsets.only(left: 4.0, right: 40.0)
                                    : EdgeInsets.only(left: 40.0, right: 4.0),
                                color: Colors.white,
                              ),
                              subtitle: Container(
                                height: 15.0,
                                width: isMyMessage
                                    ? 50.0
                                    : 120.0, // Customize width based on message direction
                                margin: isMyMessage
                                    ? EdgeInsets.only(
                                        left: 8.0,
                                        right: 40.0) // Adjust margins
                                    : EdgeInsets.only(left: 40.0, right: 8.0),
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      // If there is an error, show an error message
                      return Text(snapshot.error.toString());
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      // If there is no data or the data is empty, show a message
                      return const Text('Brak wiadomości');
                    } else {
                      var messages = snapshot.data!.docs.reversed;
                      List<Widget> messageWidgets = [];

                      for (var message in messages) {
                        var messageData =
                            message.data() as Map<String, dynamic>;
                        var messageText = messageData['message'];
                        var messageSender = messageData['senderEmail'];

                        var messageWidget = MessageWidget(
                          messageSender,
                          messageText,
                          messageSender ==
                              Auth()
                                  .userEmail(), // Check if the message is sent by the current user
                        );
                        messageWidgets.add(messageWidget);
                      }

                      return ListView(
                        reverse: true,
                        children: messageWidgets,
                      );
                    }
                  } catch (error) {
                    return const Text(
                        'Wystąpił błąd podczas pobierania wiadomości');
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Wpisz wiadomość...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    chat.sendMessage(widget.receiverId, messageController.text);
                    messageController.clear();
                  },
                ),
              ],
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

  // Add a parameter to check if the message is sent by the current user
  final bool isMyMessage;

  const MessageWidget(this.sender, this.text, this.isMyMessage, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color textColor = theme.brightness == Brightness.dark
        ? AppColors.textLight
        : AppColors.textDark;
    final Color myChat = theme.brightness == Brightness.light
        ? AppColors.navbarSelectedLight
        : AppColors.navbarSelectedDark;
    final Color otherChat = theme.brightness == Brightness.light
        ? AppColors.navbarUnselectedLight
        : AppColors.navbarUnselectedDark;

    // Display 'Ja' instead of the sender's email for the current user's messages
    // Display 'Sklep' instead of the receiver's email for the current user's messages
    final displayedSender = isMyMessage ? 'Ja' : 'Sklep';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        // Align messages based on whether they are sent by the current user or the other user
        mainAxisAlignment:
            isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: isMyMessage ? myChat : otherChat,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$displayedSender:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
