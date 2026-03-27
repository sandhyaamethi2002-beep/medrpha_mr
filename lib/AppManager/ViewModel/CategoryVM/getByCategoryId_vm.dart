import 'package:flutter/material.dart';
import '../../Models/CategoryM/getByCategoryId_model.dart';
import '../../Services/CategoryS/getByCategoryId_service.dart';

class GetByCategoryVM extends ChangeNotifier {

  final GetByCategoryService _service = GetByCategoryService();

  bool isLoading = false;

  List<ProductData> productList = [];
  List<ProductData> _allProducts = [];

  Future<void> fetchProducts() async {

    isLoading = true;
    notifyListeners();

    final response = await _service.getProductsByCategory();

    if (response != null && response.success == true) {
      productList = response.data ?? [];
      _allProducts = productList;
    }

    isLoading = false;
    notifyListeners();
  }

  void searchProduct(String query) {

    if (query.isEmpty) {
      productList = _allProducts;
    } else {
      productList = _allProducts.where((p) =>
          (p.productName ?? "")
              .toLowerCase()
              .contains(query.toLowerCase())).toList();
    }

    notifyListeners();
  }
}