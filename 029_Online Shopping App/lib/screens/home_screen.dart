import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart'; // ADD THIS IMPORT
import '../data/dummy_data.dart';
import '../widgets/product_card.dart';
import '../widgets/cart_icon.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Product> _products = dummyProducts;
  final List<CartItem> _cartItems = [];

  void _addToCart(Product product) {
    setState(() {
      final existingItemIndex = _cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );
      
      if (existingItemIndex >= 0) {
        _cartItems[existingItemIndex].quantity++;
      } else {
        _cartItems.add(CartItem(product: product));
      }
    });
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(cartItems: _cartItems),
      ),
    ).then((_) => setState(() {}));
  }

  void _navigateToProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          product: product,
          onAddToCart: () => _addToCart(product),
          cartItemCount: _totalCartItems,
        ),
      ),
    );
  }

  int get _totalCartItems {
    return _cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ShopEasy',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          CartIcon(
            itemCount: _totalCartItems,
            onPressed: _navigateToCart,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Featured Products',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  product: _products[index],
                  onAddToCart: () => _addToCart(_products[index]),
                  onTap: () => _navigateToProductDetail(_products[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}