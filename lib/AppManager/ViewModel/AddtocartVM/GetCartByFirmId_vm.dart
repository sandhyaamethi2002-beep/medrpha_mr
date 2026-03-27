import 'package:flutter/material.dart';
import '../../Models/AddtocartM/GetCartByFirmId_model.dart';
import '../../Services/AddtocartS/GetCartByFirmId_service.dart';

class GetCartByFirmIdVM extends ChangeNotifier {
  List<CartItemData> cartItems = [];
  bool loading = false;

  Future<void> fetchCart(int firmId, int userId) async {
    loading = true;
    notifyListeners();

    final response = await GetCartByFirmIdService.getCart(
      firmId: firmId,
      userTypeId: 1,
    );

    if (response != null && response.success) {
      cartItems = response.data;
    } else {
      cartItems = [];
    }

    loading = false;
    notifyListeners();
  }
}