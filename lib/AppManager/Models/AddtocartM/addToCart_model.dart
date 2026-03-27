class AddToCartResponse {
  final int totalQty;
  final double totalPrice;
  final int totalItems;

  AddToCartResponse({
    required this.totalQty,
    required this.totalPrice,
    required this.totalItems,
  });

  factory AddToCartResponse.fromJson(Map<String, dynamic> json) {
    return AddToCartResponse(
      totalQty: json['totalQty'] ?? 0,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      totalItems: json['totalItems'] ?? 0,
    );
  }
}