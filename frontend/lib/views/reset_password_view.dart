import 'package:flutter/material.dart';
import 'package:frontend/views/otp_reset_password_view.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:frontend/services/api.dart';
import 'package:frontend/widgets/login_form.dart';
import '../../../constants.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
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

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
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
        ),
      ),
    );
  }
}
