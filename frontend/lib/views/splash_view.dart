import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/views/home_view.dart';
import 'package:frontend/views/user_type_view.dart';
import 'package:frontend/widgets/logo_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  final SharedPreferences prefs;

  const SplashView({Key? key, required this.prefs}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();

    _slideController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _checkUserStatus() {
    final String? userEmail = widget.prefs.getString('user_email');
    if (userEmail != null) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeView(email: userEmail)),
        );
      });
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => const UserTypeSelectionView()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[400],
      body: Stack(
        children: [
          Center(
            child: SlideTransition(
              position: _slideAnimation,
              child: const logo_widget(),
            ),
          ),
        ],
      ),
    );
  }
}
