abstract class OtpVerificationState {}

class OtpVerificationInitial extends OtpVerificationState {}

class OtpVerificationLoading extends OtpVerificationState {}

class OtpVerificationSuccess extends OtpVerificationState {}

class OtpVerificationError extends OtpVerificationState {
  final String message;
  OtpVerificationError(this.message);
}

class OtpVerificationResent extends OtpVerificationState {
  final String newOtp;
  OtpVerificationResent(this.newOtp);
}
