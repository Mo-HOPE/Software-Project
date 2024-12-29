import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/services/api.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/widgets/custom_navigation_bar.dart';
import 'package:frontend/widgets/error_message_widget.dart';
import 'package:frontend/widgets/product_card.dart';
import 'package:frontend/widgets/category_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  final ApiService _apiService = ApiService();
  String _selectedCategory = "Men";
  late Future<List<ProductModel>> _productsFuture;
  late TextEditingController _searchController;
  Timer? _debounce;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProducts();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _productsFuture = _fetchProducts();
    });
  }

  Future<List<ProductModel>> _fetchProducts() {
    return _apiService.getProducts(_selectedCategory.toLowerCase());
  }

  void _onSearchChanged(String keyword) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (keyword.trim().isNotEmpty) {
        setState(() {
          _productsFuture = _apiService.searchProducts(keyword);
        });
      } else {
        setState(() {
          _productsFuture = _fetchProducts();
        });
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _productsFuture = _fetchProducts();
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isSearching
              ? TextField(
                  key: const ValueKey("SearchBar"),
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search products...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: _onSearchChanged,
                )
              : const Text(
                  'OutfitOn',
                  key: ValueKey("AppBarTitle"),
                ),
        ),
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: Colors.white,
          fontSize: 22.0,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: _toggleSearch,
          )
        ],
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16.0),
          if (!_isSearching)
            CategoryBar(
              categories: const ["Men", "Women", "Children"],
              selectedCategory: _selectedCategory,
              onCategorySelected: _onCategorySelected,
            ),
          if (!_isSearching) const SizedBox(height: 16.0),
          Expanded(
            child: FutureBuilder<List<ProductModel>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: CustomErrorWidget(
                          message:
                              "There was an error, please check your internet connection or try to contact us"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products available.'));
                }

                final products = snapshot.data!;

                return Padding(
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
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(product: product);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
