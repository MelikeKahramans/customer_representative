import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart'; // AuthService'i içe aktarın
import '../models/user.dart' as CustomUser;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    CustomUser.User? user = await _authService.signInWithEmail(email, password);

    if (user != null) {
      if (user.role == 'admin') {
        Navigator.pushReplacementNamed(
          context,
          '/admin',
          arguments: FirebaseAuth.instance.currentUser,
        );
      } else if (user.role == 'customer') {
        Navigator.pushReplacementNamed(
          context,
          '/customer',
          arguments: FirebaseAuth.instance.currentUser,
        );
      } else {
        // Diğer roller için yönlendirme yapılabilir
      }
    } else {
      // Giriş başarısız, kullanıcıya mesaj göster
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giriş başarısız. Lütfen bilgilerinizi kontrol edin.')),
      );
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Yap'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/gglobal.png', width: 250, height: 100),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Giriş Yap'),
              ),
              TextButton(
                onPressed: () {
                  // Kayıt ekranına yönlendirme
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text('Kayıt Ol'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}