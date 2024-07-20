import 'package:flutter/material.dart';
import '../models/message.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;
  final String currentUserId;

  const MessageList({super.key, required this.messages, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        Message message = messages[index];
        bool isMe = message.senderId == currentUserId;

        return ListTile(
          title: Text(isMe ? 'Siz' : 'Admin'),
          subtitle: Text(message.content),
          trailing: Text(message.timestamp.toString()),
        );
      },
    );
  }
}
