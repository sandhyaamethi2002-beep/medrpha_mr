class AddFirmResponseModel {
  final bool success;
  final String message;

  AddFirmResponseModel({
    required this.success,
    required this.message,
  });

  factory AddFirmResponseModel.fromJson(Map<String, dynamic> json) {
    return AddFirmResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}