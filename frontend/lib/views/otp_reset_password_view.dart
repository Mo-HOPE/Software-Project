import 'package:flutter/material.dart';
import 'package:frontend/services/api.dart';
import 'package:frontend/views/login_view.dart';

class OtpResetPasswordView extends StatelessWidget {
  final TextEditingController _otpController = TextEditingController();
  String correctOtp;
  final String email;
  final String password;

  OtpResetPasswordView({
    Key? key,
    required this.correctOtp,
    required this.email,
    required this.password,
  }) : super(key: key);

  bool _verifyOtp() {
    return correctOtp == _otpController.text.trim();
  }

  Future<void> _resendOtp(BuildContext context) async {
    try {
      final otpResponse = await ApiService().sendOtp(email: email);
      correctOtp = otpResponse.data['otp'];
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('OTP resent successfully! Check your email.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to resend OTP. Please try again.')),
      );
    }
  }

  Future<void> _changePassword(BuildContext context) async {
    try {
      await ApiService().resetPassword(email: email, newPassword: password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully!')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to change password. Please try again.')),
      );
    }
  }

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
      body: Center(
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
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_verifyOtp()) {
                          await _changePassword(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Invalid OTP. Please try again.')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
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
                        onPressed: () async => await _resendOtp(context),
                        child: const Text('Resend OTP'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
