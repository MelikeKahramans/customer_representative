import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_page.dart';
import 'screens/customer/customer_home_page.dart';
import 'screens/admin/admin_home_page.dart';
import 'screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:gglobal_g/screens/combine_chat_page.dart';
import 'package:gglobal_g/screens/customer/view_prices_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Müşteri Temsilciği Ve Fiyat Listesi',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterScreen(),
        '/customer': (context) => CustomerHomePage(user: ModalRoute.of(context)!.settings.arguments as firebase_auth.User),
        '/admin': (context) => AdminHomePage(user: ModalRoute.of(context)!.settings.arguments as firebase_auth.User),
        '/chat': (context) => CombineChatPage(user: ModalRoute.of(context)!.settings.arguments as firebase_auth.User, adminId: '',),
        '/view_prices': (context) => const ViewPricesPage(),
      },
    );
  }
}







