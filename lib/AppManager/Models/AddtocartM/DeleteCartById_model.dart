class DeleteCartByIdModel {
  final bool success;
  final String message;

  DeleteCartByIdModel({
    required this.success,
    required this.message,
  });

  factory DeleteCartByIdModel.fromJson(Map<String, dynamic> json) {
    return DeleteCartByIdModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
    );
  }
}