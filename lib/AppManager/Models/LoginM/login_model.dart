class LoginResponseModel {
  final bool success;
  final String message;
  final LoginData? data;

  LoginResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? LoginData.fromJson(json['data'])
          : null,
    );
  }
}

class LoginData {
  final int userId;
  final String userName;
  // ✅ NAYA FIELD ADD KIYA
  final int userTypeId;

  LoginData({
    required this.userId,
    required this.userName,
    required this.userTypeId, // Constructor mein update
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      userTypeId: json['userTypeId'] ?? 0,
    );
  }
}