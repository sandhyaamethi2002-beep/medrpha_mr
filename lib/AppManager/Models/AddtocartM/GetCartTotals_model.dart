class GetCartTotalsModel {
  final int totalQty;
  final double totalPrice;
  final int totalItems;

  GetCartTotalsModel({
    required this.totalQty,
    required this.totalPrice,
    required this.totalItems,
  });

  factory GetCartTotalsModel.fromJson(Map<String, dynamic> json) {
    return GetCartTotalsModel(
      totalQty: json['totalQty'] ?? 0,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      totalItems: json['totalItems'] ?? 0,
    );
  }
}