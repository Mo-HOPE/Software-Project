import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Working on that",
            style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
