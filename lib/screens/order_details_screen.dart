import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../AppManager/ViewModel/AddtocartVM/GetOrderDetails_vm.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  final Color primaryColor = const Color(0xFF1A5ED3);

  final GetOrderDetailsVM vm = Get.put(GetOrderDetailsVM());

  @override
  void initState() {
    super.initState();

    vm.fetchOrderDetails(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Order #${widget.orderId}",
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),

      body: Obx(() {

        if(vm.isLoading.value){
          return const Center(child: CircularProgressIndicator());
        }

        if(vm.orderDetails.isEmpty){
          return const Center(child: Text("No Data Found"));
        }

        final order = vm.orderDetails.first;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _sectionTitle("Order Products"),

              ...vm.orderDetails.map((item)=>_buildProductCard(item)).toList(),

              const SizedBox(height: 20),

              _sectionTitle("Order Summary"),

              _buildSummaryCard(order),

              const SizedBox(height: 20),

              _sectionTitle("Invoice Details"),

              _buildInvoiceCard(order),

              const SizedBox(height: 30),
            ],
          ),
        );

      }),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87),
      ),
    );
  }

  /// PRODUCT CARD
  Widget _buildProductCard(dynamic item) {

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10)
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              /// PRODUCT IMAGE
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://mrnew.medrpha.com/images/${item.productImg}"
                        ),
                        fit: BoxFit.cover
                    )
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text(
                      item.productName ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),

                    Text(
                      "${item.companyName} | ${item.categoryName}",
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "Qty: ${item.orderedQty} ${item.unitType}",
                      style: const TextStyle(fontSize: 14),
                    ),

                    Text(
                      "Batch: ${item.batchNumber}",
                      style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 13),
                    ),

                    Text(
                      "Expiry: ${item.dtExpiryDate != null && item.dtExpiryDate != ""
                          ? DateFormat('MMMM-yyyy').format(DateTime.parse(item.dtExpiryDate.toString()))
                          : "N/A"}",
                      style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  Text(
                    "₹${item.unitMrp}",
                    style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                        fontSize: 12),
                  ),

                  Text(
                    "₹${item.companyPrice}",
                    style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              )
            ],
          ),

          const Divider(height: 25),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Total: ₹${item.totalPrice}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  /// SUMMARY CARD
  Widget _buildSummaryCard(dynamic order) {

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Column(
        children: [

          _summaryRow("Order Date", order.orderDate ?? ""),

          _summaryRow("Order ID", order.orderId.toString()),

          _summaryRow("Status", "Placed", isStatus: true),

          const Divider(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              const Text(
                  "Total Amount",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16)
              ),

              Text(
                "₹${order.totalPrice}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// INVOICE CARD
  Widget _buildInvoiceCard(dynamic order) {

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              const Text(
                  "Transaction ID",
                  style: TextStyle(fontWeight: FontWeight.bold)
              ),

              Text(
                order.orderId.toString(),
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const Divider(height: 25),

          _invoiceRow("Product", order.productName ?? ""),

          _invoiceRow("Company", order.companyName ?? ""),

          _invoiceRow("Category", order.categoryName ?? ""),

          const Divider(height: 25),

          _invoiceRow(
              "Payment Mode",
              "CASH ON DELIVERY",
              isBold: true
          ),

          _invoiceRow("Payment Status", "Pending"),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value, {bool isStatus = false}) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          Text(
              title,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14)
          ),

          Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isStatus ? Colors.black : Colors.black87)
          ),
        ],
      ),
    );
  }

  Widget _invoiceRow(String title, String value, {bool isBold = false}) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          Text(
              title,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13)
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,

              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                  fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}