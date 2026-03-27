class GetOrderInvoiceModel {
  bool? success;
  List<InvoiceData>? data;

  GetOrderInvoiceModel({this.success, this.data});

  GetOrderInvoiceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <InvoiceData>[];
      json['data'].forEach((v) {
        data!.add(InvoiceData.fromJson(v));
      });
    }
  }
}

class InvoiceData {
  int? orderId;
  String? transactionId;
  String? orderStatusText;
  String? productName;
  String? compnayName;
  int? quantity;
  double? mrp;
  double? companyPrice;

  InvoiceData({
    this.orderId,
    this.transactionId,
    this.orderStatusText,
    this.productName,
    this.compnayName,
    this.quantity,
    this.mrp,
    this.companyPrice,
  });

  InvoiceData.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    transactionId = json['transaction_id'];
    orderStatusText = json['order_status_text'];
    productName = json['product_name'];
    compnayName = json['compnay_name'];
    quantity = json['quantity'];
    mrp = (json['mrp'] ?? 0).toDouble();
    companyPrice = (json['company_price'] ?? 0).toDouble();
  }
}