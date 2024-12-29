import 'package:flutter/material.dart';
import 'package:frontend/views/home_view.dart';
import 'package:frontend/views/profile_view.dart';
import 'package:frontend/views/cart_view.dart';
import 'package:frontend/widgets/custom_navigation_bar.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 2;

    void _onItemTapped(int index) {
      switch (index) {
        case 0:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeView()),
          );
          break;
        case 1:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const CartView()),
          );
          break;
        case 2:
          // Stay on WishlistView
          break;
        case 3:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ProfileView()),
          );
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple,
      ),
      body: const Center(
        child: Text('Your wishlist is empty!'),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
