import 'package:flutter/material.dart';
import '../../Models/AddtocartM/DeleteCartById_model.dart';
import '../../Services/AddtocartS/DeleteCartById_service.dart';

class DeleteCartByIdVM extends ChangeNotifier {

  final DeleteCartByIdService _service = DeleteCartByIdService();

  bool isLoading = false;

  Future<DeleteCartByIdModel?> deleteCart({
    required int cartId,
    required int userTypeId,
  }) async {

    isLoading = true;
    notifyListeners();

    final response = await _service.deleteCart(
      cartId: cartId,
      userTypeId: userTypeId,
    );

    isLoading = false;
    notifyListeners();

    return response;
  }
}