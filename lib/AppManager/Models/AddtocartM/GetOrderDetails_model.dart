class GetOrderDetailsModel {
  bool? success;
  List<OrderDetailsData>? data;

  GetOrderDetailsModel({this.success, this.data});

  GetOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];

    if (json['data'] != null) {
      data = <OrderDetailsData>[];
      json['data'].forEach((v) {
        data!.add(OrderDetailsData.fromJson(v));
      });
    }
  }
}

class OrderDetailsData {
  int? orderDetailsId;
  int? orderId;
  int? pid;
  String? productName;
  String? productImg;
  String? companyName;
  String? categoryName;
  double? companyPrice;
  double? unitMrp;
  int? orderedQty;
  String? unitType;
  String? batchNumber;
  String? dtExpiryDate;
  double? totalPrice;
  String? orderDate;

  OrderDetailsData.fromJson(Map<String, dynamic> json) {
    orderDetailsId = json['order_details_id'];
    orderId = json['order_id'];
    pid = json['pid'];
    productName = json['product_name'];
    productImg = json['product_img'];
    companyName = json['compnay_name'];
    categoryName = json['category_name'];
    companyPrice = (json['company_price'] ?? 0).toDouble();
    unitMrp = (json['unitMrp'] ?? 0).toDouble();
    orderedQty = json['orderedQty'];
    unitType = json['unit_type'];
    batchNumber = json['batchNumber'];
    dtExpiryDate = json['dtExpiryDate'];
    totalPrice = (json['totalPrice'] ?? 0).toDouble();
    orderDate = json['orderDate'];
  }
}