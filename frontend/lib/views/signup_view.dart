import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/views/otp_view.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:frontend/cubits/auth/auth_cubit.dart';
import 'package:frontend/services/api.dart';
import 'package:frontend/views/login_view.dart';
import 'package:frontend/widgets/Signup_form.dart';
import '../../../constants.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isLoading, // Show or hide loader
        opacity: 0.5, // Dim background
        progressIndicator: const CircularProgressIndicator(
          color: Colors.purple, // Purple loader
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "assets/images/customer2.webp",
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create your first account !",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Please enter valid data in order to create an account.",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    SignUpForm(
                      formKey: _formKey,
                      nameController: _nameController,
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
                                          builder: (context) => BlocProvider(
                                            create: (context) =>
                                                OtpVerificationCubit(
                                              apiService: ApiService(),
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                              name: _nameController.text,
                                              correctOtp: correctOtp,
                                            ),
                                            child: OtpVerificationView(
                                              email: _emailController.text,
                                            ),
                                          ),
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                    } catch (e) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Please enter a valid Gmail'),
                                        ),
                                      );
                                    }
                                  } else if (checkCustomerExist ==
                                      "Invalid credentials") {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'User already exists, try to login'),
                                      ),
                                    );
                                  } else {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Do you have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginView(),
                              ),
                            );
                          },
                          child: const Text("Log in"),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
