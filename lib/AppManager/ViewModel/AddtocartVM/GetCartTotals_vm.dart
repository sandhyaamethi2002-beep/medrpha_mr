import '../../Models/AddtocartM/GetCartTotals_model.dart';
import '../../Services/AddtocartS/GetCartTotals_service.dart';
import 'package:flutter/material.dart';

class GetCartTotalsVM with ChangeNotifier {
  GetCartTotalsModel? cartTotals;

  bool isLoading = false;

  Future<void> fetchCartTotals({
    required int firmId,
    required int userTypeId,
  }) async {
    isLoading = true;
    notifyListeners();

    cartTotals = await GetCartTotalsService.getCartTotals(
      firmId: firmId,
      userTypeId: userTypeId,
    );

    isLoading = false;
    notifyListeners();
  }
}