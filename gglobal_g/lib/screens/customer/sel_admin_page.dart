import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as CustomUser;
import 'package:gglobal_g/screens/customer/chat_page.dart';

class AdminSelectionPage extends StatelessWidget {
  final CustomUser.User user;

  const AdminSelectionPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yetikili Seçimi')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'admin').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var admins = snapshot.data!.docs;
          return ListView.builder(
            itemCount: admins.length,
            itemBuilder: (context, index) {
              var admin = admins[index];
              return ListTile(
                title: Text(admin['email']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerChatScreen(user: user, adminId: admin.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
