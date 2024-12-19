<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:frontend/views/otp_reset_password_view.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:frontend/services/api.dart';
=======
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:frontend/services/api.dart';
import 'package:frontend/views/home_view.dart';
>>>>>>> 689abbc099bc4bb9dace3e5f3f8a386b1f2450af
import 'package:frontend/widgets/login_form.dart';
import '../../../constants.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
<<<<<<< HEAD
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
=======
  State<ResetPasswordView> createState() => _LoginViewState();
}

class _LoginViewState extends State<ResetPasswordView> {
>>>>>>> 689abbc099bc4bb9dace3e5f3f8a386b1f2450af
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        backgroundColor: Colors.purple,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        opacity: 0.5,
        progressIndicator: const CircularProgressIndicator(
          color: Colors.purple,
        ),
<<<<<<< HEAD
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: defaultPadding * 2),
                  const Text(
                    "Enter your email and the new password",
                    style: TextStyle(fontSize: 18),
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
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });

                                final checkCustomerExist =
                                    await ApiService().checkCustomerExists(
                                  email: _emailController.text,
                                );

                                if (checkCustomerExist == "User not found") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'This email does not ecist, try to create an account'),
                                    ),
                                  );
                                } else if (checkCustomerExist ==
                                    "Invalid credentials") {
                                  try {
                                    final otpResponse =
                                        await ApiService().sendOtp(
                                      email: _emailController.text,
                                    );
                                    final String correctOtp =
                                        otpResponse.data['otp'];
=======
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: defaultPadding * 2),
                    const Text(
                      "Enter your email and new password",
                      style: TextStyle(fontSize: 22),
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
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  try {
                                    final loginResponse =
                                        await ApiService().loginCustomer(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );
>>>>>>> 689abbc099bc4bb9dace3e5f3f8a386b1f2450af

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
<<<<<<< HEAD
                                          builder: (context) =>
                                              OtpResetPasswordView(
                                                correctOtp: correctOtp,
                                                email: _emailController.text,
                                                password:
                                                    _passwordController.text,
                                              )),
                                      (Route<dynamic> route) => false,
                                    );
                                  } catch (e) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Please enter a valid Gmail'),
                                      ),
                                    );
                                  }
                                }
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.purple[400]),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
=======
                                        builder: (context) => const HomeView(),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                  } on DioException catch (e) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    if (e.response != null) {
                                      if (e.response?.data['error'] ==
                                          'Invalid credentials') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Invalid password, please try again'),
                                          ),
                                        );
                                      } else if (e.response?.data['error'] ==
                                          'User not found') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'This user does not exist'),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                }
                              },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.purple[400]),
                        ),
                        child: const Text(
                          "Continue",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
>>>>>>> 689abbc099bc4bb9dace3e5f3f8a386b1f2450af
        ),
      ),
    );
  }
}