import 'package:flutter/material.dart';

class TrackOrdersScreen extends StatelessWidget {
  const TrackOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Orders'),
        backgroundColor: Colors.purple,
      ),
      body: const Center(
        child: Text(
          'No orders to track yet!',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
