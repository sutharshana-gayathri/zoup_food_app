import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/food_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Consumer<FoodProvider>(
        builder: (ctx, foodProvider, child) {
          final cartItems = foodProvider.cartItems.entries.where((entry) => entry.value.quantity > 0).toList();
          if (cartItems.isEmpty) {
            return const Center(child: Text('Your cart is empty!'));
          }

          double subtotal = cartItems.fold(0, (sum, entry) {
            final foodItem = foodProvider.foodItems.firstWhere((item) => item.id == entry.key);
            return sum + (foodItem.price * entry.value.quantity);
          });
          double restaurantTax = subtotal * 0.05; // 5% restaurant tax
          double gst = subtotal * 0.18; // 18% GST
          double total = subtotal + restaurantTax + gst;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: cartItems.length,
                  itemBuilder: (ctx, i) {
                    final foodItem = foodProvider.foodItems.firstWhere((item) => item.id == cartItems[i].key);
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            foodItem.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                        title: Text(foodItem.name),
                        subtitle: Text('Price per item: ₹${foodItem.price.toStringAsFixed(2)}'),
                        trailing: Text(
                          'Qty: ${cartItems[i].value.quantity} | Total: ₹${(cartItems[i].value.quantity * foodItem.price).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal', style: TextStyle(fontSize: 16)),
                        Text('₹${subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Restaurant Tax (5%)', style: TextStyle(fontSize: 16)),
                        Text('₹${restaurantTax.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('GST (18%)', style: TextStyle(fontSize: 16)),
                        Text('₹${gst.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('₹${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}