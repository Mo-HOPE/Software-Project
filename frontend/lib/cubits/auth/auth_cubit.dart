import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubits/auth/auth_states.dart';
import 'package:frontend/services/api.dart';

class OtpVerificationCubit extends Cubit<OtpVerificationState> {
  final ApiService apiService;
  final String name;
  final String email;
  final String password;
  String correctOtp;

  OtpVerificationCubit({
    required this.apiService,
    required this.name,
    required this.email,
    required this.password,
    required this.correctOtp,
  }) : super(OtpVerificationInitial());

  Future<void> verifyOtp(String enteredOtp) async {
    if (enteredOtp.isEmpty) {
      emit(OtpVerificationError('Please enter the OTP.'));
      return;
    }

    if (enteredOtp == correctOtp) {
      emit(OtpVerificationLoading());
      try {
        final response = await ApiService().createCustomer(
          name: name,
          email: email,
          password: password,
        );
        if (response.statusCode == 201) {
          emit(OtpVerificationSuccess());
        } else {
          emit(OtpVerificationError('Failed to create user. Try again.'));
        }
      } on DioException catch (e) {
        emit(OtpVerificationError(
            'Error creating user: ${e.response?.data ?? e.message}'));
      }
    } else {
      emit(OtpVerificationError('The OTP is incorrect.'));
    }
  }

  Future<void> resendOtp() async {
    emit(OtpVerificationLoading());
    try {
      final response = await apiService.sendOtp(email: email);
      if (response.statusCode == 200) {
        final data = response.data;
        final newOtp = data['otp'] as String?;
        if (newOtp != null) {
          correctOtp = newOtp;
          emit(OtpVerificationResent(newOtp));
        } else {
          emit(OtpVerificationError('Failed to retrieve new OTP.'));
        }
      } else {
        emit(OtpVerificationError('Failed to send OTP. Please try again.'));
      }
    } on DioException catch (e) {
      emit(OtpVerificationError('Error: ${e.response?.data ?? e.message}'));
    }
  }
}
