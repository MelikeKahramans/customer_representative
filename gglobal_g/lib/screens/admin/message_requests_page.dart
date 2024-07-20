import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as CustomUser;
import 'package:gglobal_g/screens/combine_chat_page.dart';

class AdminChatScreen extends StatelessWidget {
  final CustomUser.User admin;
  final String customerId;

  const AdminChatScreen({Key? key, required this.admin, required this.customerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CombineChatPage(user: admin, adminId: customerId),
    );
  }
}


