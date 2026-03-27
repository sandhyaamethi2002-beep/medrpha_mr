import 'package:flutter/material.dart';
import '../../Models/AddtocartM/addToCart_model.dart';
import '../../Services/AddtocartS/addToCart_service.dart';

class AddToCartVM with ChangeNotifier {
  final AddToCartService _service = AddToCartService();

  AddToCartResponse? _cartResponse;
  bool _isLoading = false;

  AddToCartResponse? get cartResponse => _cartResponse;
  bool get isLoading => _isLoading;

  Future<void> addToCartApi({
    required int productId,
    required int firmId,
    required int userId,
    required int qty,
    required double unitPrice,
    required int wpid,
    required int priceId,
    required int userTypeId,
  }) async {
    _isLoading = true;
    notifyListeners();

    _cartResponse = await _service.addToCart(
      productId: productId,
      firmId: firmId,
      userId: userTypeId,
      qty: qty,
      unitPrice: unitPrice,
      wpid: wpid,
      priceId: priceId,
      userTypeId: userTypeId,
    );

    _isLoading = false;
    notifyListeners();
  }
}