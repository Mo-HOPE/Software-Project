import 'package:flutter/material.dart';

class logo_widget extends StatelessWidget {
  const logo_widget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/app_logo.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // App Name
        const Text(
          "OutfitOn",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: "Times new roman",
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
