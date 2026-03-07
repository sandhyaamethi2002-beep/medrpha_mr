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
  String? productName;
  String? productImg;
  String? companyName;
  String? categoryName;
  String? description;
  String? productType;

  /// ⭐ NEW FIELDS ADDED
  double? mrp;
  double? finalCompanyPrice;
  double? discountPercentage;

  ProductData({
    this.pid,
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
    productName = json['product_name'];
    productImg = json['product_img'];

    // Note: Aapne 'compnay_name' likha tha (spelling check karein API ke hisab se)
    companyName = json['compnay_name'] ?? json['company_name'];

    categoryName = json['category_name'];
    description = json['description'];
    productType = json['product_type'];

    /// ⭐ MAPPING NEW FIELDS FROM JSON
    // .toDouble() lagana zaroori hai taaki int values bhi double ban jayein
    mrp = json['mrp']?.toDouble();
    finalCompanyPrice = json['finalCompanyPrice']?.toDouble();
    discountPercentage = json['discountPercentage']?.toDouble();
  }
}