import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.email});
  final String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            Text("$email", style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
