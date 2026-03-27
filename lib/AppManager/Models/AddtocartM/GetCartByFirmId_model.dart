class GetCartByFirmIdResponse {
  final bool success;
  final String message;
  final List<CartItemData> data;

  GetCartByFirmIdResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetCartByFirmIdResponse.fromJson(Map<String, dynamic> json) {
    return GetCartByFirmIdResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CartItemData.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class CartItemData {
  final int cartId;
  final int productId;
  final String productName;
  final int minOrderQty;
  final int qty;
  final int quantityMin;
  final int quantityMax;
  final String? quantityType;
  final int wpid;
  final double sellingPrice;

  CartItemData({
    required this.cartId,
    required this.productId,
    required this.productName,
    required this.minOrderQty,
    required this.qty,
    required this.quantityMin,
    required this.quantityMax,
    this.quantityType,
    required this.wpid,
    required this.sellingPrice,
  });

  factory CartItemData.fromJson(Map<String, dynamic> json) {
    return CartItemData(
      cartId: json['cartId'] ?? 0,
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      minOrderQty: json['min_order_qty'] ?? 0,
      qty: json['qty'] ?? 0,
      quantityMin: json['quantitymin'] ?? 0,
      quantityMax: json['quantitymax'] ?? 0,
      quantityType: json['quantity_type'],
      wpid: json['wpid'] ?? 0,
      sellingPrice: (json['sellingPrice'] ?? 0).toDouble(),
    );
  }

  get mrp => null;
}