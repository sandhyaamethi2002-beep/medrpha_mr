import 'package:flutter/material.dart';
// Sahi model import karein
import '../AppManager/Models/CategoryM/getProductDetail_model.dart';

class SavedProvider with ChangeNotifier {
  // Yahan ProductModel ki jagah ProductData karein
  final List<ProductData> _savedItems = [];

  // Getter ka return type bhi List<ProductData> hona chahiye
  List<ProductData> get savedItems => _savedItems;

  // Toggle Save/Unsave logic
  void toggleSaveProduct(ProductData product) {
    // pid use karein check karne ke liye kyunki ProductData mein pid hai
    final isExist = _savedItems.any((item) => item.pid == product.pid);

    if (isExist) {
      _savedItems.removeWhere((item) => item.pid == product.pid);
    } else {
      _savedItems.add(product);
    }
    notifyListeners();
  }

  // Check if product is already saved
  bool isSaved(String productId) {
    // productId String mein aata hai, isliye toString() se compare karein
    return _savedItems.any((item) => item.pid.toString() == productId);
  }
}