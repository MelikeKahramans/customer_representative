import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;
  final Function(String, double)? onUpdatePrice;

  const ProductList({super.key, required this.products, this.onUpdatePrice});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        Product product = products[index];
        TextEditingController priceController = TextEditingController(text: product.price.toString());

        return ListTile(
          title: Text(product.name),
          subtitle: onUpdatePrice != null
              ? TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Fiyat'),
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) {
                    double newPrice = double.parse(value);
                    onUpdatePrice!(product.id, newPrice);
                  },
                )
              : Text('Fiyat: ${product.price.toString()}'),
        );
      },
    );
  }
}
