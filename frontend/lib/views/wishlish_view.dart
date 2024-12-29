import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/models/customer_model.dart';
import 'package:frontend/services/api.dart';
import 'package:frontend/views/home_view.dart';
import 'package:frontend/views/profile_view.dart';
import 'package:frontend/views/cart_view.dart';
import 'package:frontend/widgets/custom_navigation_bar.dart';
import 'package:frontend/widgets/error_message_widget.dart';
import 'package:frontend/widgets/product_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistView extends StatefulWidget {
  const WishlistView({super.key});

  @override
  State<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends State<WishlistView> {
  int _selectedIndex = 2;
  final ApiService _apiService = ApiService();
  late Future<List<ProductModel>> _wishlistProductsFuture;

  @override
  void initState() {
    super.initState();
    _wishlistProductsFuture = _fetchWishlistProducts();
  }

  Future<List<ProductModel>> _fetchWishlistProducts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email');

      if (email == null) {
        throw Exception('No email found in shared preferences.');
      }

      final customer = await _apiService.getCustomerInfo(email);
      if (customer.wishlistProducts.isEmpty) {
        return [];
      }

      // Fetch each product individually using its ID
      List<ProductModel> products = [];
      for (int id in customer.wishlistProducts) {
        final product = await _apiService.getProductInfo(id);
        products.add(product);
      }

      return products;
    } catch (e) {
      throw Exception('Error fetching wishlist products: $e');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wishlist',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _wishlistProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: CustomErrorWidget(
                message: 'Error: ${snapshot.error}',
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Your wishlist is empty!'),
            );
          }

          final wishlistProducts = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 3 / 4,
              ),
              itemCount: wishlistProducts.length,
              itemBuilder: (context, index) {
                final product = wishlistProducts[index];
                return ProductCard(product: product);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
