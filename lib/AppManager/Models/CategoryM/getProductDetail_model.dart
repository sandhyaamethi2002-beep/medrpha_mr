class ProductDetailModel {
  bool? success;
  List<ProductData>? data;

  ProductDetailModel({this.success, this.data});

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ProductData>[];
      json['data'].forEach((v) => data!.add(ProductData.fromJson(v)));
    }
  }
}

class ProductData {
  int? pid;
  String? categoryId;
  String? productName;
  String? productImg;
  String? description;
  int? mrp;
  double? finalCompanyPrice;
  int? discountPercentage;
  String? companyName; // Yeh field add ki hai

  ProductData({
    this.pid,
    this.productName,
    this.productImg,
    this.description,
    this.mrp,
    this.finalCompanyPrice,
    this.discountPercentage,
    this.companyName,
    this.categoryId,
  });

  ProductData.fromJson(Map<String, dynamic> json) {
    pid = json['pid'];
    productName = json['product_name'];
    productImg = json['product_img'];
    description = json['description'];
    companyName = json['company_name'];

    mrp = int.tryParse(json['mrp']?.toString() ?? "0") ?? 0;
    finalCompanyPrice = double.tryParse(json['finalCompanyPrice']?.toString() ?? "0") ?? 0.0;
    discountPercentage = int.tryParse(json['discountPercentage']?.toString() ?? "0") ?? 0;
  }
}