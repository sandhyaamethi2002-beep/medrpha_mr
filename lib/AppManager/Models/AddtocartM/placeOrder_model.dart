class PlaceOrderRequest {
  int userId;
  int userTypeId;
  int roleId;
  double orderAmount;
  int payModeId;
  String transactionId;
  int paymentStatus;
  String address;
  String country;
  String state;
  String city;
  String phone;
  String email;
  String name;

  PlaceOrderRequest({
    required this.userId,
    required this.userTypeId,
    required this.roleId,
    required this.orderAmount,
    required this.payModeId,
    required this.transactionId,
    required this.paymentStatus,
    required this.address,
    required this.country,
    required this.state,
    required this.city,
    required this.phone,
    required this.email,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "userTypeId": userTypeId,
      "roleId": roleId,
      "orderAmount": orderAmount,
      "payModeId": payModeId,
      "transactionId": transactionId,
      "paymentStatus": paymentStatus,
      "address": address,
      "country": country,
      "state": state,
      "city": city,
      "phone": phone,
      "email": email,
      "name": name,
    };
  }
}

class PlaceOrderResponse {
  int orderId;
  double orderAmount;
  String message;
  bool success;

  PlaceOrderResponse({
    required this.orderId,
    required this.orderAmount,
    required this.message,
    required this.success,
  });

  factory PlaceOrderResponse.fromJson(Map<String, dynamic> json) {
    return PlaceOrderResponse(
      orderId: json["orderId"] ?? 0,
      orderAmount: (json["orderAmount"] ?? 0).toDouble(),
      message: json["message"] ?? "",
      success: json["success"] ?? false,
    );
  }
}