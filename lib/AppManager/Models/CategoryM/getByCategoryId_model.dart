class GetByCategoryIdModel {
  bool? success;
  String? message;
  List<ProductData>? data;

  GetByCategoryIdModel({
    this.success,
    this.message,
    this.data,
  });

  GetByCategoryIdModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];

    if (json['data'] != null) {
      data = <ProductData>[];
      json['data'].forEach((v) {
        data!.add(ProductData.fromJson(v));
      });
    }
  }
}

class ProductData {
  int? pid;
  int? adminid;
  int? userId;
  int? areaId;
  String? productName;
  String? productImg;
  String? companyName;
  String? categoryName;
  String? description;
  String? productType;


  /// PRICE FIELDS
  double? mrp;
  double? finalCompanyPrice;
  double? discountPercentage;

  ProductData({
    this.pid,
    this.adminid,
    this.userId,
    this.areaId,
    this.productName,
    this.productImg,
    this.companyName,
    this.categoryName,
    this.description,
    this.productType,
    this.mrp,
    this.finalCompanyPrice,
    this.discountPercentage,
  });

  ProductData.fromJson(Map<String, dynamic> json) {

    pid = json['pid'];
    adminid = json['adminId'];
    userId = json['userid'];
    areaId = json['areaId'];

    productName = json['product_name'];
    productImg = json['product_img'];

    // Sometimes API typo compnay_name
    companyName = json['compnay_name'] ?? json['company_name'];

    categoryName = json['category_name'];
    description = json['description'];
    productType = json['product_type'];

    /// SAFE DOUBLE PARSING
    mrp = _parseDouble(json['mrp']);
    finalCompanyPrice = _parseDouble(json['finalCompanyPrice']);
    discountPercentage = _parseDouble(json['discountPercentage']);
  }

  /// Helper function to safely convert dynamic → double
  double? _parseDouble(dynamic value) {
    if (value == null) return null;

    if (value is int) return value.toDouble();
    if (value is double) return value;

    return double.tryParse(value.toString());
  }
}