class LoginOtpModel {
  final bool status;
  final bool alreadyRegistered;
  final String message;
  final String otp;

  LoginOtpModel({
    required this.status,
    required this.alreadyRegistered,
    required this.message,
    required this.otp,
  });

  factory LoginOtpModel.fromJson(Map<String, dynamic> json) {
    return LoginOtpModel(
      status: json['status'] ?? false,
      alreadyRegistered: json['alreadyRegistered'] ?? false,
      message: json['message'] ?? '',
      otp: json['otp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "alreadyRegistered": alreadyRegistered,
      "message": message,
      "otp": otp,
    };
  }
}