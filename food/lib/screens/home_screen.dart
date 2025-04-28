import 'package:flutter/material.dart';
import 'food_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> featuredDishes = [
      {
        'name': 'Pizza',
        'imageUrl': 'https://images.pexels.com/photos/315755/pexels-photo-315755.jpeg',
      },
      {
        'name': 'Sandwich',
        'imageUrl': 'https://images.pexels.com/photos/1633578/pexels-photo-1633578.jpeg',
      },
      {
        'name': 'Pasta',
        'imageUrl': 'https://images.pexels.com/photos/8500/food-dinner-pasta-spaghetti-8500.jpg',
      },
      {
        'name': 'Momos',
        'imageUrl': 'https://images.pexels.com/photos/5409009/pexels-photo-5409009.jpeg',
      },
    ];

    final List<String> quotes = [
      '“The best food is made with love!”',
      '“Taste the difference at Zoup Restaurant.”',
      '“Every bite tells a story.”',
      '“Fresh ingredients, delicious meals.”',
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner Image
            Image(
              image: NetworkImage('https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg'),
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Banner image load failed - Error: $error');
                return const Icon(Icons.error, size: 100, color: Colors.red);
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const CircularProgressIndicator();
              },
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            // Restaurant Name and Tagline
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Zoup Restaurant',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  Text(
                    'Savor the Flavor!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Quotes Section
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: quotes.map((quote) => Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    quote,
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87, // Dark text color
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 20),
            // Featured Dishes
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Featured Dishes',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: featuredDishes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(featuredDishes[index]['imageUrl']),
                          child: const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          featuredDishes[index]['name'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FoodListScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('View Full Menu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}