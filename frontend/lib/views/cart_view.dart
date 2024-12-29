import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/services/api.dart';
import 'package:frontend/views/home_view.dart';
import 'package:frontend/views/profile_view.dart';
import 'package:frontend/views/wishlish_view.dart';
import 'package:frontend/widgets/custom_navigation_bar.dart';
import 'package:frontend/widgets/error_message_widget.dart';
import 'package:frontend/widgets/product_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  int _selectedIndex = 1;
  final ApiService _apiService = ApiService();
  late Future<List<ProductModel>> _cartProductsFuture;

  @override
  void initState() {
    super.initState();
    _cartProductsFuture = _fetchCartProducts();
  }

  Future<List<ProductModel>> _fetchCartProducts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email');

      if (email == null) {
        throw Exception('No email found in shared preferences.');
      }

      final customer = await _apiService.getCustomerInfo(email);
      if (customer.cartProducts.isEmpty) {
        return [];
      }

      List<ProductModel> products = [];
      for (int id in customer.cartProducts) {
        final product = await _apiService.getProductInfo(id);
        products.add(product);
      }

      return products;
    } catch (e) {
      throw Exception('Error fetching cart products: $e');
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
        // Stay on CartView
        break;
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WishlistView()),
        );
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
          'Cart',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _cartProductsFuture,
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
              child: Text('Your cart is empty!'),
            );
          }

          final cartProducts = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: cartProducts.length,
                    itemBuilder: (context, index) {
                      final product = cartProducts[index];
                      return ProductCard(product: product);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.all(16.0),
                    ),
                    child: const Text(
                      'Make Order',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
