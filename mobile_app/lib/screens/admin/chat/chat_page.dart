import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/constants/colors.dart';
import 'package:mobile_app/service/authentication/auth.dart';
import 'package:mobile_app/service/chat/chat.dart';

class AdminChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;

  const AdminChatPage({
    Key? key,
    required this.receiverEmail,
    required this.receiverId,
  }) : super(key: key);

  @override
  State<AdminChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<AdminChatPage> {
  final TextEditingController messageController = TextEditingController();
  final Chat chat = Chat();

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await Chat().sendMessage(widget.receiverId, messageController.text);
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.receiverId}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: chat.getMessages(Auth().userId(), widget.receiverId),
                builder: (context, snapshot) {
                  try {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // If the stream is still waiting for data, show a loading indicator
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // If there is an error, show an error message
                      return Text(snapshot.error.toString());
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      // If there is no data or the data is empty, show a message
                      return const Text('No messages available.');
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
                    return const Text('An error occurred (catched)');
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
                      hintText: 'Type your message...',
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
    final Color textColor = theme.brightness == Brightness.light
        ? AppColors.textLight
        : AppColors.textDark;
    const Color myChat = AppColors.chatCurrent;
    const Color otherChat = AppColors.chatOther;

    // Display 'Me' instead of the sender's email for the current user's messages
    final displayedSender = isMyMessage ? 'Me' : sender;

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
