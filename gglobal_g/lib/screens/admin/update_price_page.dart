import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../../models/product.dart';

class UpdatePricePage extends StatefulWidget {
  const UpdatePricePage({super.key});

  @override
  _UpdatePricePageState createState() => _UpdatePricePageState();
}

class _UpdatePricePageState extends State<UpdatePricePage> {
  final FirestoreService _firestoreService = FirestoreService();
  late Stream<List<Product>> _productsStream;
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _productsStream = _firestoreService.getProducts();
  }

  void _updatePrice(String productId, double newPrice) {
    if (productId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçersiz ürün kimliği')),
      );
      return;
    }
    _firestoreService.updateProductPrice(productId, newPrice).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fiyat güncellendi: $newPrice')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fiyat güncellenemedi: $error')),
      );
    });
  }

  void _addProduct() {
    String name = _nameController.text.trim();
    double? price = double.tryParse(_priceController.text.trim());

    if (name.isEmpty || price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçersiz ürün adı veya fiyat')),
      );
      return;
    }

    _firestoreService.addProduct(name, price).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ürün eklendi: $name - $price')));
      _nameController.clear();
      _priceController.clear();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ürün eklenemedi: $error')),
      );
    });
  }

  void _deleteProduct(String productId) {
    _firestoreService.deleteProduct(productId).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ürün silindi')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ürün silinemedi: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fiyat Listesi Güncelle'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Ürün Adı'),
                ),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Fiyat'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: _addProduct,
                  child: const Text('Ürün Ekle'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Product>>(
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
                    TextEditingController priceController = TextEditingController(text: product.price.toString());

                    return ListTile(
                      title: Text(product.name),
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: priceController,
                              decoration: const InputDecoration(labelText: 'Fiyat'),
                              keyboardType: TextInputType.number,
                              onSubmitted: (value) {
                                try {
                                  double newPrice = double.parse(value);
                                  _updatePrice(product.id, newPrice);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Geçersiz fiyat formatı')),
                                  );
                                }
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteProduct(product.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
