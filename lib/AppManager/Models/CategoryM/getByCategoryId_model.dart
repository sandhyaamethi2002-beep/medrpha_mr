class GetByCategoryModel {
  bool? success;
  String? message;
  List<ProductData>? data;

  GetByCategoryModel({this.success, this.message, this.data});

  GetByCategoryModel.fromJson(Map<String, dynamic> json) {
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
  String? description;
  String? categoryName;
  int? status;

  ProductData({
    this.pid,
    this.productName,
    this.productImg,
    this.companyName,
    this.description,
    this.categoryName,
    this.status,
  });

  ProductData.fromJson(Map<String, dynamic> json) {
    pid = json['pid'];
    productName = json['product_name'];
    productImg = json['product_img'];
    companyName = json['compnay_name'];
    description = json['description'];
    categoryName = json['category_name'];
    status = json['status'];
  }
}