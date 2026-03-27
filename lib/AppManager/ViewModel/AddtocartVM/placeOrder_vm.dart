import 'package:flutter/material.dart';
import '../../Models/AddtocartM/placeOrder_model.dart';
import '../../Services/AddtocartS/placeOrder_service.dart';

class PlaceOrderVM extends ChangeNotifier {

  final PlaceOrderService _service = PlaceOrderService();

  bool isLoading = false;

  Future<PlaceOrderResponse?> placeOrder(PlaceOrderRequest request) async {

    isLoading = true;
    notifyListeners();

    final response = await _service.placeOrder(request);

    isLoading = false;
    notifyListeners();

    return response;
  }
}