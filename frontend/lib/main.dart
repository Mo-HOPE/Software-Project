import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/views/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(OutfitOn(prefs: prefs));
}

class OutfitOn extends StatelessWidget {
  final SharedPreferences prefs;

  const OutfitOn({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashView(prefs: prefs),
      theme: ThemeData(),
    );
  }
}
