import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart' as CustomUser;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _role = 'customer'; // Varsayılan rol

  void _register() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    CustomUser.User? user = await _authService.registerWithEmail(email, password, _role);

    if (user != null) {
      print('Kullanıcı kaydedildi: ${user.email}');
      // Kayıt başarılı, kullanıcıyı başka bir ekrana yönlendirin veya bilgilendirin
    } else {
      print('Kullanıcı kaydı başarısız');
      // Kayıt başarısız, kullanıcıya hata mesajı gösterin
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            DropdownButton<String>(
              value: _role,
              onChanged: (String? newValue) {
                setState(() {
                  _role = newValue!;
                });
              },
              items: <String>['admin', 'customer']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}
