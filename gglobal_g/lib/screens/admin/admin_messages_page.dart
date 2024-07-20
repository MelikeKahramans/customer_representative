import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gglobal_g/screens/admin/message_requests_page.dart'; // Admin'in mesajlaşacağı sayfa

class AdminMessagesPage extends StatelessWidget {
  final User admin;

  const AdminMessagesPage({Key? key, required this.admin}) : super(key: key);

Future<String?> getUserEmail(String userId) async {
  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return userDoc['email'];
    } else {
      print('Kullanıcı bulunamadı.');
      return null;
    }
  } catch (e) {
    print('Kullanıcı e-postası alınırken hata oluştu: $e');
    return null;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Müşterilerden Gelen Mesajlar'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .where('senderId', isEqualTo: admin.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var senderMessages = snapshot.data!.docs;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('messages')
                .where('receiverId', isEqualTo: admin.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              var receiverMessages = snapshot.data!.docs;

              // Tüm mesajları tek bir listeye toplama
              var allMessages = [...senderMessages, ...receiverMessages];

              // Müşteri kimliklerini bir set içinde saklamak
              var customerIds = <String>{};
              for (var message in allMessages) {
                if (message['senderId'] == admin.uid) {
                  customerIds.add(message['receiverId']);
                } else {
                  customerIds.add(message['senderId']);
                }
              }

              // Müşteri kimliklerini listelemek
              return ListView.builder(
                itemCount: customerIds.length,
                itemBuilder: (context, index) {
                  var customerId = customerIds.elementAt(index);
                  return FutureBuilder<String?>(
                    future: getUserEmail(customerId),
                    builder: (context, emailSnapshot) {
                      if (emailSnapshot.connectionState == ConnectionState.waiting) {
                        return ListTile(
                          title: const Text('Yükleniyor...'),
                        );
                      }
                      if (emailSnapshot.hasError) {
                        return ListTile(
                          title: Text('Hata: ${emailSnapshot.error}'),
                        );
                      }
                      var email = emailSnapshot.data ?? 'E-posta bulunamadı';
                      return ListTile(
                        title: Text('Müşteri: $email'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminChatScreen(
                                admin: admin,
                                customerId: customerId,
                              ),
                            ),
                          );
                        },
                      );
                    },
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
