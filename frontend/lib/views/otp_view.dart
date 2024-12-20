import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubits/auth/auth_cubit.dart';
import 'package:frontend/cubits/auth/auth_states.dart';
import 'package:frontend/views/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerificationView extends StatelessWidget {
  final TextEditingController _otpController = TextEditingController();
  final String email;

  OtpVerificationView({Key? key, required this.email}) : super(key: key);

  void _verifyOtp(BuildContext context) {
    final cubit = context.read<OtpVerificationCubit>();
    cubit.verifyOtp(_otpController.text.trim());
  }

  void _resendOtp(BuildContext context) {
    final cubit = context.read<OtpVerificationCubit>();
    cubit.resendOtp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        backgroundColor: Colors.purple,
      ),
      body: BlocConsumer<OtpVerificationCubit, OtpVerificationState>(
        listener: (context, state) async {
          if (state is OtpVerificationSuccess) {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.setString('user_email', email);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User registered successfully!')),
            );

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeView(),
              ),
              (Route<dynamic> route) => false,
            );
          } else if (state is OtpVerificationResent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('OTP resent successfully! Check your email.')),
            );
          }
        },
        builder: (context, state) {
          bool isLoading = state is OtpVerificationCubit;
          String? errorMessage;
          if (state is OtpVerificationError) {
            errorMessage = state.message;
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Enter the OTP sent to your email',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your OTP',
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (errorMessage != null && errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 16),
                  if (isLoading)
                    const CircularProgressIndicator()
                  else
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => _verifyOtp(context),
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.purple),
                            ),
                            child: const Text(
                              'Verify',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Didn’t get the code?"),
                            TextButton(
                              onPressed: () => _resendOtp(context),
                              child: const Text('Resend OTP'),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
