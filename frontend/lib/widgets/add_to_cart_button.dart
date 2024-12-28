import 'package:flutter/material.dart';

class AddToCartButton extends StatelessWidget {
  final bool isDisabled;
  final VoidCallback onTap;

  const AddToCartButton({
    super.key,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? Colors.grey : Colors.purple,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: Text(
          isDisabled ? 'Sold Out' : 'Add to Cart',
          style: const TextStyle(fontSize: 18.0, color: Colors.white),
        ),
      ),
    );
  }
}
