import 'package:flutter/material.dart';
import '../AppManager/Models/AddtocartM/GetCartTotals_model.dart';
import '../AppManager/Models/CategoryM/getProductDetail_model.dart';
import '../AppManager/Services/AddtocartS/GetCartByFirmId_service.dart';
import '../AppManager/ViewModel/AddtocartVM/GetCartByFirmId_vm.dart';
import '../AppManager/ViewModel/AddtocartVM/GetCartTotals_vm.dart';
import '../AppManager/ViewModel/AddtocartVM/addToCart_vm.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CartItem {
  final ProductData product;
  int quantity;
  int cartId;

  CartItem({
    required this.product,
    required this.quantity,
    this.cartId = 0,
  });
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};
  final AddToCartVM addToCartVM = AddToCartVM();
  final GetCartByFirmIdVM getCartVM = GetCartByFirmIdVM();
  final GetCartTotalsVM getCartTotalsVM = GetCartTotalsVM();

  GetCartTotalsModel? cartTotals;
  bool _isLoading = false;
  bool _isProcessing = false;

  Map<String, CartItem> get items => _items;
  bool get isLoading => _isLoading;
  bool get isProcessing => _isProcessing;

  // --- RESTORED GETTERS FOR UI ---
  int get totalItems => _items.length;

  int get totalCartQty {
    int count = 0;
    _items.forEach((key, item) => count += item.quantity);
    return count;
  }

  double get totalCartAmount {
    double total = 0.0;
    _items.forEach((key, item) {
      double price = double.tryParse(item.product.finalCompanyPrice.toString()) ?? 0.0;
      total += price * item.quantity;
    });
    return total;
  }

  double get totalMrpAmount {
    double total = 0.0;
    _items.forEach((key, item) {
      double mrp = item.product.mrp ?? (double.tryParse(item.product.finalCompanyPrice.toString()) ?? 0.0);
      total += mrp * item.quantity;
    });
    return total;
  }

  double get totalDiscount {
    double mrpTotal = totalMrpAmount;
    double apiFinalPrice = cartTotals?.totalPrice ?? totalCartAmount;
    double diff = mrpTotal - apiFinalPrice;
    return diff > 0 ? diff : 0.0;
  }

  int getProductQuantity(String productId) => _items[productId]?.quantity ?? 0;

  // --- CORE LOGIC METHODS ---

  /// LOAD CART (Updated to handle quantityMin and clean unit prices)
  Future<void> loadCart({required int firmId, required int userTypeId}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await GetCartByFirmIdService.getCart(
          firmId: firmId,
          userTypeId: userTypeId
      );

      _items.clear();

      if (response != null && response.success) {
        for (var item in response.data) {
          String pId = item.productId.toString();

          // FIX: Calculate actual unit price (Total / Qty)
          // because the API 'sellingPrice' is currently the Total Price.
          double totalFromApi = item.sellingPrice;
          int itemQty = item.qty > 0 ? item.qty : 1;
          double actualUnitPrice = totalFromApi / itemQty;

          _items[pId] = CartItem(
            cartId: item.cartId,
            quantity: item.qty,
            product: ProductData(
              pid: item.productId,
              productName: item.productName,
              finalCompanyPrice: actualUnitPrice, // Storing cleaned Unit Price
              mrp: (item.mrp != null && item.mrp! > 0) ? item.mrp : actualUnitPrice,
              wpid: item.wpid,
              // FIX: Use quantityMin as the source of truth for increments
              minQty: item.quantityMin,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Load Cart Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
      await fetchCartTotals(firmId: firmId, userTypeId: userTypeId);
    }
  }

  /// UPDATED ADD TO CART with explicit minQty parameter
  Future<void> addToCart({
    required ProductData product,
    required int firmId,
    required int userId,
    int? minQty, // Optional: Pass explicit step quantity
  }) async {
    if (_isProcessing) return;

    final String productId = product.pid.toString();
    int step = minQty ?? int.tryParse(product.minQty?.toString() ?? "1") ?? 1;
    if (step <= 0) step = 1;

    int currentQty = _items[productId]?.quantity ?? 0;
    int newTotalQty = currentQty + step;

    double unitPrice = double.tryParse(product.finalCompanyPrice.toString()) ?? 0.0;

    double unitMrp = (product.mrp != null && product.mrp! > 0)
        ? product.mrp!
        : unitPrice;

    // Local Update
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity = newTotalQty;
    } else {
      _items[productId] = CartItem(product: product, quantity: newTotalQty);
    }
    notifyListeners();

    _isProcessing = true;
    try {
      await addToCartVM.addToCartApi(
        productId: product.pid ?? 0,
        firmId: firmId,
        userId: userId,
        qty: step,
        unitPrice: unitPrice,
        wpid: product.wpid ?? 0,
        priceId: product.wpid ?? 0,
        userTypeId: 1,
      );
      await fetchCartTotals(firmId: firmId, userTypeId: 1);
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  /// UPDATED REMOVE FROM CART
  Future<void> removeFromCart(
      String productId, {
        required int firmId,
        required int userId,
        int? minQty,
      }) async {
    if (!_items.containsKey(productId) || _isProcessing) return;

    final cartItem = _items[productId]!;
    int step = minQty ?? int.tryParse(cartItem.product.minQty?.toString() ?? "1") ?? 1;
    if (step <= 0) step = 1;

    int currentQty = cartItem.quantity;
    int nextQty = currentQty - step;

    // BUG FIX: Remove item if next quantity would be 0 or less
    if (nextQty <= 0) {
      debugPrint("Min quantity reached. Removing item completely.");
      await removeFromCartCompletely(
          productId: productId,
          firmId: firmId,
          userId: userId
      );
    } else {
      // Otherwise, just decrement
      _items[productId]!.quantity = nextQty;
      notifyListeners();

      _isProcessing = true;
      try {
        await addToCartVM.addToCartApi(
          productId: cartItem.product.pid ?? 0,
          firmId: firmId,
          userId: userId,
          qty: -step,
          unitPrice: cartItem.product.finalCompanyPrice ?? 0,
          wpid: cartItem.product.wpid ?? 0,
          priceId: cartItem.product.wpid ?? 0,
          userTypeId: 1,
        );
        await fetchCartTotals(firmId: firmId, userTypeId: 1);
      } finally {
        _isProcessing = false;
        notifyListeners();
      }
    }
  }

  // RESTORED: Needed for Cart Screen Dialog
  Future<void> clearCartFromServer({required int firmId, required int userId}) async {
    _isLoading = true;
    notifyListeners();
    try {
      for (var item in _items.values) {
        await addToCartVM.addToCartApi(
          productId: item.product.pid ?? 0,
          firmId: firmId,
          userId: userId,
          qty: 0, // 0 usually clears it on additive APIs
          unitPrice: item.product.finalCompanyPrice ?? 0,
          wpid: item.product.wpid ?? 0,
          priceId: item.product.wpid ?? 0,
          userTypeId: 1,
        );
      }
      _items.clear();
    } finally {
      _isLoading = false;
      notifyListeners();
      await fetchCartTotals(firmId: firmId, userTypeId: 1);
    }
  }

  Future<void> updateQuantityManually({
    required ProductData product,
    required int newQty,
    required int firmId,
    required int userId,
  }) async {
    if (_isProcessing) return;
    final String productId = product.pid.toString();

    int minQty = int.tryParse(product.minQty?.toString() ?? "1") ?? 1;
    if (minQty <= 0) minQty = 1;

    // Safety: Round to nearest multiple
    if (newQty > 0 && newQty % minQty != 0) {
      newQty = (newQty / minQty).ceil() * minQty;
    }

    _isProcessing = true;
    try {
      // API call for manual override (Assuming it sets total if qty=total)
      await addToCartVM.addToCartApi(
        productId: product.pid ?? 0,
        firmId: firmId,
        userId: userId,
        qty: newQty,
        unitPrice: product.finalCompanyPrice ?? 0,
        wpid: product.wpid ?? 0,
        priceId: product.wpid ?? 0,
        userTypeId: 1,
      );

      if (newQty <= 0) {
        _items.remove(productId);
      } else {
        _items[productId] = CartItem(product: product, quantity: newQty);
      }
      await fetchCartTotals(firmId: firmId, userTypeId: 1);
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<void> removeFromCartCompletely({
    required String productId,
    required int firmId,
    required int userId,
  }) async {
    if (!_items.containsKey(productId)) return;
    final int cartId = _items[productId]!.cartId;
    final url = "https://mrnew.medrpha.com/api/Cart/DeleteCartById/$cartId/$userId";

    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        _items.remove(productId);
        notifyListeners();
        await fetchCartTotals(firmId: firmId, userTypeId: 1);
      }
    } catch (e) {
      debugPrint("Delete Error: $e");
    }
  }

  Future<void> fetchCartTotals({required int firmId, required int userTypeId}) async {
    await getCartTotalsVM.fetchCartTotals(firmId: firmId, userTypeId: userTypeId);
    cartTotals = getCartTotalsVM.cartTotals;
    notifyListeners();
  }
}