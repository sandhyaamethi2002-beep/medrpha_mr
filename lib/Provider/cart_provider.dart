import 'package:flutter/material.dart';
import '../controllers/product_controller.dart';

class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });
}

class CartProvider with ChangeNotifier {

  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get totalItems => _items.length;

  /// GET PRODUCT QUANTITY
  int getProductQuantity(String productId) {
    return _items[productId]?.quantity ?? 0;
  }

  /// ADD TO CART
  void addToCart(ProductModel product) {

    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(
        product: product,
        quantity: 1,
      );
    }

    notifyListeners();
  }

  /// REMOVE FROM CART
  void removeFromCart(String productId) {

    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity == 1) {
      _items.remove(productId);
    } else {
      _items[productId]!.quantity--;
    }

    notifyListeners();
  }

}