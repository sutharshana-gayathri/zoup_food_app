import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/food_item.dart';

class FoodProvider with ChangeNotifier {
  List<FoodItem> _foodItems = [];
  final Map<String, CartItem> _cartItems = {};

  List<FoodItem> get foodItems => _foodItems;
  Map<String, CartItem> get cartItems => _cartItems;

  static final List<FoodItem> _predefinedFoodItems = [
    FoodItem(
      id: '1',
      name: 'Masala Dosa',
      description: 'A golden dosa stuffed with spiced potato filling, served with coconut chutney and sambar. A South Indian classic with a perfect balance of textures.',
      price: 120.0,
      imageUrl: 'https://images.pexels.com/photos/3764641/pexels-photo-3764641.jpeg',
      ingredients: 'Rice batter\nUrad dal (black gram)\nPotatoes\nMustard seeds\nCurry leaves\nTurmeric powder\nSalt\nGhee/oil',
    ),
    FoodItem(
      id: '2',
      name: 'Penne Arrabbiata',
      description: 'Spicy penne pasta tossed in a bold tomato sauce with garlic and red chili flakes for a fiery kick, served hot.',
      price: 120.0,
      imageUrl: 'https://images.pexels.com/photos/12737611/pexels-photo-12737611.jpeg',
      ingredients: 'Penne pasta\nTomatoes\nGarlic\nRed chili flakes\nOlive oil\nSalt\nBlack pepper\nFresh basil',
    ),
    FoodItem(
      id: '3',
      name: 'Pepperoni Pizza',
      description: 'Loaded with spicy pepperoni and melted cheese topping, baked to perfection with a crispy crust and rich flavors.',
      price: 200.0,
      imageUrl: 'https://images.pexels.com/photos/315755/pexels-photo-315755.jpeg',
      ingredients: 'Pizza dough\nMozzarella cheese\nPepperoni slices\nTomato sauce\nOlive oil\nOregano\nSalt\nBasil leaves',
    ),
  ];

  FoodProvider() {
    _foodItems = List.from(_predefinedFoodItems);
    fetchFoodItems();
  }

  Future<void> fetchFoodItems() async {
    const url = 'http://192.168.1.4:3000/food-items';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final fetchedItems = data.map((item) => FoodItem.fromJson(item)).toList();
        _foodItems = [..._predefinedFoodItems, ...fetchedItems]
          ..sort((a, b) => a.id.compareTo(b.id));
      }
    } catch (error) {
      print('Error fetching food items: $error');
    }
    notifyListeners();
  }

  Future<void> addFoodItem(Map<String, dynamic> foodItem) async {
    const url = 'http://192.168.1.4:3000/food-items';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(foodItem),
      );
      if (response.statusCode == 201) {
        final newFoodItem = FoodItem.fromJson(json.decode(response.body));
        _foodItems.add(newFoodItem);
      }
    } catch (error) {
      _foodItems.add(FoodItem(
        id: foodItem['id'],
        name: foodItem['name'],
        description: foodItem['description'],
        price: foodItem['price'],
        imageUrl: foodItem['imageUrl'],
        ingredients: foodItem['ingredients'],
      ));
      print('Added item locally due to error: $error');
    }
    notifyListeners();
  }

  Future<void> updateFoodItem(String id, FoodItem updatedFoodItem) async {
    final url = 'http://192.168.1.4:3000/food-items/$id';
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedFoodItem.toJson()),
      );
      if (response.statusCode == 200) {
        final index = _foodItems.indexWhere((item) => item.id == id);
        if (index != -1) _foodItems[index] = updatedFoodItem;
      }
    } catch (error) {
      final index = _foodItems.indexWhere((item) => item.id == id);
      if (index != -1) _foodItems[index] = updatedFoodItem;
      print('Updated item locally due to error: $error');
    }
    notifyListeners();
  }

  Future<void> deleteFoodItem(String id) async {
    final url = 'http://192.168.1.4:3000/food-items/$id';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        _foodItems.removeWhere((item) => item.id == id);
      }
    } catch (error) {
      _foodItems.removeWhere((item) => item.id == id);
      print('Deleted item locally due to error: $error');
    }
    notifyListeners();
  }

  void incrementCartItem(String id) {
    if (_cartItems.containsKey(id)) {
      _cartItems[id]!.quantity += 1;
    } else {
      _cartItems[id] = CartItem(id: id, quantity: 1);
    }
    notifyListeners();
  }

  void decrementCartItem(String id) {
    if (_cartItems.containsKey(id) && _cartItems[id]!.quantity > 0) {
      _cartItems[id]!.quantity -= 1;
      if (_cartItems[id]!.quantity == 0) {
        _cartItems.remove(id);
      }
    }
    notifyListeners();
  }
}

class CartItem {
  final String id;
  int quantity;

  CartItem({required this.id, this.quantity = 0});
}