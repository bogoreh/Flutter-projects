import 'package:flutter/material.dart';
import '../data/restaurant_data.dart';
import '../models/restaurant.dart';
import '../widgets/category_chip.dart';
import '../widgets/menu_item_card.dart';
import 'cart_screen.dart';

class MenuScreen extends StatefulWidget {
  final Restaurant restaurant;

  const MenuScreen({super.key, required this.restaurant});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Appetizers', 'Main Course', 'Desserts', 'Drinks'];
  final Map<String, int> cartItems = {};

  @override
  Widget build(BuildContext context) {
    final filteredItems = selectedCategory == 'All'
        ? RestaurantData.menuItems
        : RestaurantData.menuItems
            .where((item) => item.category == selectedCategory)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.name),
        centerTitle: true,
        actions: [
          if (cartItems.isNotEmpty)
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cartItems.values
                          .fold(0, (sum, quantity) => sum + quantity)
                          .toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.restaurant,
                    color: Color(0xFF2E7D32),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.restaurant.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.restaurant.description,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber.shade700,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.restaurant.rating.toString(),
                          style: TextStyle(
                            color: Colors.amber.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Menu Categories
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryChip(
                    label: categories[index],
                    isSelected: selectedCategory == categories[index],
                    onTap: () {
                      setState(() {
                        selectedCategory = categories[index];
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Menu Items
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return MenuItemCard(
                    item: item,
                    onAddToCart: () {
                      setState(() {
                        cartItems[item.id] = (cartItems[item.id] ?? 0) + 1;
                      });
                      _showAddedToCartSnackbar(item.name);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddedToCartSnackbar(String itemName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$itemName added to cart!'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}