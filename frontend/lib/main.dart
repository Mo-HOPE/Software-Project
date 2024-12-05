import 'package:flutter/material.dart';
import 'package:frontend/views/splash_view.dart';

void main() {
  runApp(const OutfitOn());
}

class OutfitOn extends StatelessWidget {
  const OutfitOn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashView(),
      theme: ThemeData(),
    );
  }
}
