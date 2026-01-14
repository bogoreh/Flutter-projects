import '../models/menu_item.dart';
import '../models/restaurant.dart';

class RestaurantData {
  static final List<Restaurant> restaurants = [
    Restaurant(
      id: '1',
      name: 'Green Leaf Restaurant',
      description: 'Fresh organic food with vegan options',
      rating: 4.5,
      imageUrl: 'assets/restaurant1.jpg',
      category: 'Vegetarian',
    ),
    Restaurant(
      id: '2',
      name: 'Spice Palace',
      description: 'Authentic Indian cuisine',
      rating: 4.7,
      imageUrl: 'assets/restaurant2.jpg',
      category: 'Asian',
    ),
    Restaurant(
      id: '3',
      name: 'Italian Corner',
      description: 'Traditional Italian pasta and pizza',
      rating: 4.3,
      imageUrl: 'assets/restaurant3.jpg',
      category: 'Italian',
    ),
    Restaurant(
      id: '4',
      name: 'Burger Hub',
      description: 'Gourmet burgers and fries',
      rating: 4.2,
      imageUrl: 'assets/restaurant4.jpg',
      category: 'American',
    ),
  ];

  static final List<MenuItem> menuItems = [
    MenuItem(
      id: '1',
      name: 'Margherita Pizza',
      description: 'Classic pizza with tomato sauce, mozzarella, and basil',
      price: 12.99,
      imageUrl: 'assets/pizza.jpg',
      category: 'Main Course',
      isVegetarian: true,
      preparationTime: 15,
    ),
    MenuItem(
      id: '2',
      name: 'Grilled Salmon',
      description: 'Fresh salmon with lemon butter sauce and vegetables',
      price: 22.50,
      imageUrl: 'assets/salmon.jpg',
      category: 'Main Course',
      isSpicy: false,
      preparationTime: 20,
    ),
    MenuItem(
      id: '3',
      name: 'Caesar Salad',
      description: 'Crisp romaine lettuce with parmesan and croutons',
      price: 9.99,
      imageUrl: 'assets/salad.jpg',
      category: 'Appetizers',
      isVegetarian: true,
      preparationTime: 10,
    ),
    MenuItem(
      id: '4',
      name: 'Chocolate Lava Cake',
      description: 'Warm chocolate cake with molten center and vanilla ice cream',
      price: 7.50,
      imageUrl: 'assets/cake.jpg',
      category: 'Desserts',
      isVegetarian: true,
      preparationTime: 12,
    ),
    MenuItem(
      id: '5',
      name: 'Spicy Chicken Wings',
      description: 'Crispy chicken wings with spicy buffalo sauce',
      price: 11.99,
      imageUrl: 'assets/wings.jpg',
      category: 'Appetizers',
      isSpicy: true,
      preparationTime: 15,
    ),
    MenuItem(
      id: '6',
      name: 'Beef Burger',
      description: 'Juicy beef patty with cheese, lettuce, and special sauce',
      price: 14.99,
      imageUrl: 'assets/burger.jpg',
      category: 'Main Course',
      preparationTime: 18,
    ),
  ];
}