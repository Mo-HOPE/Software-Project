import 'package:flutter/material.dart';
import 'package:frontend/widgets/product_card.dart';
import 'package:google_fonts/google_fonts.dart';

<<<<<<< HEAD
class HomeView extends StatefulWidget {
  const HomeView({super.key});

=======
class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.email});
  final String email;
>>>>>>> 38d8364775d8c37b5cf5c2e1abdeeea01aeb1765
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(
        title: const Text('OutfitOn'),
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: Colors.white,
          fontSize: 22.0,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 3 / 4,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return ProductCard(
              title: 'Product $index',
              price: '\$${(index + 1) * 10}',
              imageUrl:
                  'https://i8.amplience.net/i/jpl/jd_729932_a?qlt=92&w=950&h=1212&v=1&fmt=auto',
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped,
=======
      body: Center(
        child:
            Text("$email", style: Theme.of(context).textTheme.headlineMedium),
>>>>>>> 38d8364775d8c37b5cf5c2e1abdeeea01aeb1765
      ),
    );
  }
}
