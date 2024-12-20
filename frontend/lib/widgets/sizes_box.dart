import 'package:flutter/material.dart';

class SizesBox extends StatelessWidget {
  final List<String> sizes;

  const SizesBox({
    super.key,
    required this.sizes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        sizes.join(' | '),
        style: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
