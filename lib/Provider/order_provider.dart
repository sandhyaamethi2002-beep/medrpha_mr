import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final String date;
  final String status;

  OrderItem({
    required this.id,
    required this.amount,
    required this.date,
    required this.status
  });
}

class OrderProvider with ChangeNotifier {

  final List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];

  /// Order Details API ka response store karne ke liye
  Map<String, dynamic>? orderDetails;

  void addOrder(OrderItem order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  /// ORDER DETAILS API
  Future<void> getOrderDetails(int orderId) async {

    final uri = Uri.parse(
        "https://mrnew.medrpha.com/api/Cart/GetOrderDetails/$orderId");

    print("----------- ORDER DETAILS API -----------");
    print("URI : $uri");
    print("REQUEST : orderId = $orderId");

    try {

      final response = await http.get(uri);

      print("STATUS CODE : ${response.statusCode}");
      print("RESPONSE : ${response.body}");

      if (response.statusCode == 200) {

        orderDetails = json.decode(response.body);

        notifyListeners();
      }

    } catch (e) {

      print("ORDER DETAILS API ERROR : $e");

    }

    print("-----------------------------------------");

  }

}