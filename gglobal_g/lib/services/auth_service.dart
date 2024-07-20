import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as CustomUser;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kullanıcı kaydı metodu
  Future<CustomUser.User?> registerWithEmail(String email, String password, String role) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user != null) {
        CustomUser.User newUser = CustomUser.User(id: user.uid, email: email, role: role);
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        return newUser;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  // Giriş metodu
  Future<CustomUser.User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user != null) {
        DocumentSnapshot userData = await _firestore.collection('users').doc(user.uid).get();
        return CustomUser.User.fromMap(userData.data() as Map<String, dynamic>);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  // Çıkış metodu
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Mevcut kullanıcıyı alma metodu
  Future<CustomUser.User?> getCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await _firestore.collection('users').doc(user.uid).get();
      return CustomUser.User.fromMap(userData.data() as Map<String, dynamic>);
    }
    return null;
  }
}


