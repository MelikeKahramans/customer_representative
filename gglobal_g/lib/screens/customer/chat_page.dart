import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as CustomUser;
import 'package:gglobal_g/screens/combine_chat_page.dart';

class CustomerChatScreen extends StatelessWidget {
  final CustomUser.User user;
  final String adminId;

  const CustomerChatScreen({Key? key, required this.user, required this.adminId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CombineChatPage(user: user, adminId: adminId),
    );
  }
}

