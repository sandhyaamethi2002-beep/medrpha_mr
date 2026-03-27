class GetOrdersByFirmResponse {
  final bool success;
  final List<OrderData> data;

  GetOrdersByFirmResponse({
    required this.success,
    required this.data,
  });

  factory GetOrdersByFirmResponse.fromJson(Map<String, dynamic> json) {
    return GetOrdersByFirmResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List)
          .map((e) => OrderData.fromJson(e))
          .toList(),
    );
  }
}

class OrderData {
  final int orderId;
  final double totalAmount;
  final String paymentStatus;
  final String firmName;
  final String address;
  final String phone;
  final String city;
  final String state;
  final String date;
  final String time;
  final String status;

  OrderData({
    required this.orderId,
    required this.totalAmount,
    required this.paymentStatus,
    required this.firmName,
    required this.address,
    required this.phone,
    required this.city,
    required this.state,
    required this.date,
    required this.time,
    required this.status,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      orderId: json['order_id'] ?? 0,
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      paymentStatus: json['payment_status_text'] ?? '',
      firmName: json['firm_name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phoneno'] ?? '',
      city: json['citynameadmin'] ?? '',
      state: json['statenameadmin'] ?? '',
      date: json['placed_date'] ?? '',
      time: json['placed_time'] ?? '',
      status: json['order_status_text'] ?? '',
    );
  }
}