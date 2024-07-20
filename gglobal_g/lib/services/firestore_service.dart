import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  Future<void> updateProductPrice(String productId, double newPrice) {
    return _db.collection('products').doc(productId).update({'price': newPrice});
  }

  Future<void> addProduct(String name, double price) {
    return _db.collection('products').add({'name': name, 'price': price});
  }

  Future<void> deleteProduct(String productId) {
    return _db.collection('products').doc(productId).delete();
  }
}


