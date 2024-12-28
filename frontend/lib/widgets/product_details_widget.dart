import 'package:flutter/material.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/views/product_info_view.dart';

class ProductDetails extends StatelessWidget {
  final ProductModel product;
  final String? selectedSize;
  final ValueChanged<String> onSizeSelected;

  const ProductDetails({
    super.key,
    required this.product,
    required this.selectedSize,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isInStock = product.stockQuantity > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          "Price: \$${product.priceAfterDiscount}",
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        SellerBadge(seller: product.seller),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Icon(
              isInStock ? Icons.check_circle : Icons.error,
              color: isInStock ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8.0),
            Text(
              isInStock ? "In Stock" : "Sold Out",
              style: TextStyle(
                color: isInStock ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Center(
          child: Wrap(
            spacing: 8.0,
            children: product.sizesList.map((size) {
              final isSelected = size == selectedSize;
              return ChoiceChip(
                label: Text(size),
                selected: isSelected,
                onSelected: (selected) => onSizeSelected(size),
                selectedColor: Colors.purple,
                backgroundColor: Colors.grey[200],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16.0),
        Text(
          "Description:\n${product.description}",
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
