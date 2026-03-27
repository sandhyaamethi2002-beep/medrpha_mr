// 1. MAIN WRAPPER CLASS
class ProductDetailsModel {
  bool? success;
  List<ProductData>? data;

  ProductDetailsModel({this.success, this.data});

  ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ProductData>[];
      json['data'].forEach((v) {
        data!.add(ProductData.fromJson(v));
      });
    }
  }
}

// 2. DATA CLASS (Updated with Discount)
class ProductData {
  int? pid;
  String? productName;
  String? categoryName;
  String? companyName;
  String? productImg;
  String? productType;
  String? unitType;
  String? description;
  double? mrp;
  double? finalCompanyPrice;
  double? discount;
  int? minQty;
  int? available_quantity;

  int? wpid;
  int? priceId;

  ProductData({
    this.pid,
    this.productName,
    this.categoryName,
    this.companyName,
    this.productImg,
    this.productType,
    this.unitType,
    this.description,
    this.mrp,
    this.finalCompanyPrice,
    this.discount,
    this.minQty,
    this.available_quantity,

    this.wpid,
    this.priceId,
  });

  ProductData.fromJson(Map<String, dynamic> json) {
    pid = json['pid'];
    productName = json['product_name']?.toString().trim() ?? "Unknown Product";
    categoryName = json['category_name']?.toString() ?? "N/A";
    companyName = json['company_name']?.toString() ?? "Unknown Company";
    productImg = json['product_img']?.toString() ?? "noimage.png";
    productType = json['product_type']?.toString();
    unitType = json['unit_type']?.toString() ?? "";
    description = json['description']?.toString() ?? "";

    // Parsing with safety
    mrp = _toDouble(json['mrp']);
    finalCompanyPrice = _toDouble(json['finalCompanyPrice'] ?? json['company_price']);
    discount = _toDouble(json['discount']);

    minQty = int.tryParse(json['min_order_qty']?.toString() ?? "1") ?? 1;

    available_quantity = int.tryParse(json['available_quantity']?.toString() ?? json['available_quantity']?.toString() ?? "999") ?? 999;
    wpid = json['wpid'] ?? 0;
    priceId = json['priceId'] ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}