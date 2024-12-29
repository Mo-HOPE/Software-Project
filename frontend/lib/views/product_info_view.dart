import 'package:flutter/material.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/services/api.dart';
import 'package:frontend/models/customer_model.dart';
import 'package:frontend/widgets/add_to_cart_button.dart';
import 'package:frontend/widgets/product_details_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductInfoView extends StatefulWidget {
  const ProductInfoView({super.key, required this.product});
  final ProductModel product;

  @override
  State<ProductInfoView> createState() => _ProductInfoViewState();
}

class _ProductInfoViewState extends State<ProductInfoView> {
  final ApiService _apiService = ApiService();
  CustomerModel? _customer;
  bool isWishlisted = false;
  String? selectedSize;

  @override
  void initState() {
    super.initState();
    _fetchCustomerInfo();
  }

  Future<void> _fetchCustomerInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');

    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No email found')),
      );
      return;
    }

    try {
      final customer = await _apiService.getCustomerInfo(email);
      setState(() {
        _customer = customer;
        isWishlisted = customer.wishlistProducts.contains(widget.product.id);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch customer info: $e')),
      );
    }
  }

  Future<void> _updateCustomerInfo() async {
    if (_customer == null) return;

    try {
      await _apiService.updateCustomerInfo(
        email: _customer!.email,
        name: _customer!.name,
        wishlistProducts: _customer!.wishlistProducts,
        cartProducts: _customer!.cartProducts,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update customer info: $e')),
      );
    }
  }

  void toggleWishlist() async {
    if (_customer == null) return;

    setState(() {
      if (isWishlisted) {
        _customer!.wishlistProducts.remove(widget.product.id);
      } else {
        _customer!.wishlistProducts.add(widget.product.id);
      }
      isWishlisted = !isWishlisted;
    });

    await _updateCustomerInfo();
  }

  void addToCart() async {
    if (_customer == null || selectedSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            selectedSize == null
                ? 'Please select a size.'
                : 'Failed to add to cart.',
          ),
        ),
      );
      return;
    }

    if (!_customer!.cartProducts.contains(widget.product.id) &&
        widget.product.stockQuantity > 0) {
      setState(() {
        _customer!.cartProducts.add(widget.product.id);
      });

      await _updateCustomerInfo();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added to cart.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product already in cart.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OutfitOn'),
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: Colors.white,
          fontSize: 22.0,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: isWishlisted ? Colors.red : Colors.grey,
            ),
            onPressed: toggleWishlist,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImage(photo: widget.product.photo),
            const SizedBox(height: 16.0),
            ProductDetails(
              product: widget.product,
              selectedSize: selectedSize,
              onSizeSelected: (size) => setState(() {
                selectedSize = size;
              }),
            ),
            const SizedBox(height: 16.0),
            AddToCartButton(
              isDisabled: widget.product.stockQuantity == 0,
              onTap: addToCart,
            ),
          ],
        ),
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  final String photo;

  const ProductImage({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.network(
          photo,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class SellerBadge extends StatelessWidget {
  final String seller;

  const SellerBadge({super.key, required this.seller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.store, size: 18.0),
        const SizedBox(width: 8.0),
        Text(
          "Seller: $seller",
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
