import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/views/reset_password_view.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:frontend/services/api.dart';
import 'package:frontend/views/home_view.dart';
import 'package:frontend/widgets/login_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      final loginResponse = await ApiService().loginCustomer(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', _emailController.text.trim());

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeView(email: _emailController.text.trim()),
        ),
        (Route<dynamic> route) => false,
      );
    } on DioException catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (e.response != null) {
        if (e.response?.data['error'] == 'Invalid credentials') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid password, please try again'),
            ),
          );
        } else if (e.response?.data['error'] == 'User not found') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This user does not exist'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occurred, please try again later'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to connect to the server'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An unexpected error occurred'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        opacity: 0.5,
        progressIndicator: const CircularProgressIndicator(
          color: Colors.purple,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "assets/images/customer1.jpg",
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: defaultPadding * 2),
                    Text(
                      "Welcome back !",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    LoginForm(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController,
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.purple[400],
                          ),
                        ),
                        child: const Text(
                          "Continue",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Forget your password?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResetPasswordView(),
                              ),
                            );
                          },
                          child: const Text("Reset password"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
