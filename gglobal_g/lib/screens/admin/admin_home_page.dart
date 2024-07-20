import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as CustomUser;
import 'package:gglobal_g/screens/admin/update_price_page.dart';
import 'package:gglobal_g/screens/admin/admin_messages_page.dart';
import 'package:gglobal_g/screens/login_page.dart';  // LoginPage'i içe aktarın

class AdminHomePage extends StatelessWidget {
  final CustomUser.User user;

  const AdminHomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Buton genişlik ve yükseklik ayarları
    final buttonWidth = MediaQuery.of(context).size.width * 0.8;
    final buttonHeight = 60.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yetkili Ana Sayfası'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Hoşgeldiniz, ${user.email}!'),
            const SizedBox(height: 30),
            SizedBox(
              width: buttonWidth,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminMessagesPage(admin: user)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  padding: EdgeInsets.all(15),
                ),
                child: const Text('Mesajlaşma', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: buttonWidth,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UpdatePricePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  padding: EdgeInsets.all(15),
                ),
                child: const Text('Fiyat Listesi Güncelle', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: buttonWidth,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: () async {
                  await CustomUser.FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()),  // LoginPage'e yönlendirir
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  padding: EdgeInsets.all(15),
                ),
                child: const Text('Çıkış Yap', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
