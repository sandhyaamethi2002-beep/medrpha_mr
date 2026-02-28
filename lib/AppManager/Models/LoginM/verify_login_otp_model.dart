class VerifyLoginOtpModel {
  final bool? status;
  final String? message;

  VerifyLoginOtpModel({
    this.status,
    this.message,
  });

  factory VerifyLoginOtpModel.fromJson(Map<String, dynamic> json) {
    return VerifyLoginOtpModel(
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
    };
  }
}