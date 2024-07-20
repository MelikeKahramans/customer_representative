import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../../models/product.dart';

class ViewPricesPage extends StatefulWidget {
  const ViewPricesPage({super.key});

  @override
  _ViewPricesPageState createState() => _ViewPricesPageState();
}

class _ViewPricesPageState extends State<ViewPricesPage> {
  final FirestoreService _firestoreService = FirestoreService();
  late Stream<List<Product>> _productsStream;

  @override
  void initState() {
    super.initState();
    _productsStream = _firestoreService.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fiyat Listesi'),
      ),
      body: StreamBuilder<List<Product>>(
        stream: _productsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Product> products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              Product product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('Fiyat: ${product.price.toString()}'),
              );
            },
          );
        },
      ),
    );
  }
}
