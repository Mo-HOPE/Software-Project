import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        Text(
          "OutfitOn",
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 32.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
