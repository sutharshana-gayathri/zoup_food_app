import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/food_provider.dart';
import 'food_form_screen.dart';
import 'cart_screen.dart';
import 'description_screen.dart';

class FoodListScreen extends StatelessWidget {
  const FoodListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FoodFormScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<FoodProvider>(context, listen: false).fetchFoodItems(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Consumer<FoodProvider>(
              builder: (ctx, foodProvider, child) {
                if (foodProvider.foodItems.isEmpty) {
                  return const Center(child: Text('No food items available. Add some!'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: foodProvider.foodItems.length,
                  itemBuilder: (ctx, i) => Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DescriptionScreen(foodItem: foodProvider.foodItems[i]),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                child: Image.network(
                                  foodProvider.foodItems[i].imageUrl,
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    debugPrint('Image load failed for URL: ${foodProvider.foodItems[i].imageUrl} - Error: $error');
                                    return const Icon(Icons.error, color: Colors.red, size: 50);
                                  },
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            onPressed: () {
                                              foodProvider.deleteFoodItem(foodProvider.foodItems[i].id);
                                            },
                                          ),
                                        ],
                                      ),
                                      Text(
                                        foodProvider.foodItems[i].name,
                                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Price: ₹${foodProvider.foodItems[i].price.toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        final quantity = foodProvider.cartItems[foodProvider.foodItems[i].id]?.quantity ?? 0;
                                        debugPrint('Decrement: Item ID ${foodProvider.foodItems[i].id}, Quantity: $quantity');
                                        if (quantity > 0) {
                                          foodProvider.decrementCartItem(foodProvider.foodItems[i].id);
                                        }
                                      },
                                    ),
                                    Text(
                                      '${foodProvider.cartItems[foodProvider.foodItems[i].id]?.quantity ?? 0}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        foodProvider.incrementCartItem(foodProvider.foodItems[i].id);
                                      },
                                    ),
                                  ],
                                ),
                                Text(
                                  'Total: ₹${(foodProvider.cartItems[foodProvider.foodItems[i].id]?.quantity ?? 0) * foodProvider.foodItems[i].price}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          child: const Text('Add to Cart'),
        ),
      ),
    );
  }
}