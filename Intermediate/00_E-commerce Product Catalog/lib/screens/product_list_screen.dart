import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_item.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  final List<Product> products = const [
    Product(
      id: '1',
      title: 'Wireless Headphones',
      description: 'High-quality wireless headphones with noise cancellation.',
      price: 99.99,
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      id: '2',
      title: 'Smart Watch',
      description: 'Fitness tracker with heart rate monitor.',
      price: 149.99,
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      id: '3',
      title: 'Bluetooth Speaker',
      description: 'Portable speaker with 20h battery life.',
      price: 59.99,
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      id: '4',
      title: 'Phone Case',
      description: 'Durable case with shock absorption.',
      price: 19.99,
      imageUrl: 'https://via.placeholder.com/150',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (ctx, index) => ProductItem(
          product: products[index],
        ),
      ),
    );
  }
}