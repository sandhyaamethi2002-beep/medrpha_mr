import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../Provider/cart_provider.dart';
import '../screens/place_order_screen.dart';

class BillSummaryWidget extends StatelessWidget {
  final int firmId;
  final int userId;
  final int roleId;
  final int userTypeId;
  final String? address;
  final String? phoneno;
  final String? firmName;

  final bool isPlaceOrderPage;
  final VoidCallback? onButtonClick;

  const BillSummaryWidget({
    super.key,
    required this.firmId,
    required this.roleId,
    required this.userTypeId,
    required this.userId,
    this.address,
    this.phoneno,
    this.firmName,
    this.isPlaceOrderPage = false,
    this.onButtonClick,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    // --- MANUAL CALCULATION LOGIC FOR MRP & DISCOUNT ---
    double calculatedMrpTotal = 0.0;
    double calculatedSellingTotal = 0.0;

    // Har item par loop chala kar Total MRP aur Total Selling Price nikalna
    cartProvider.items.forEach((key, item) {
      double unitPrice = double.tryParse(item.product.finalCompanyPrice.toString()) ?? 0.0;

      // Agar product model mein MRP hai toh wo lein, nahi toh price hi lein
      double unitMrp = (item.product.mrp != null && item.product.mrp! > 0)
          ? item.product.mrp!
          : unitPrice;

      calculatedMrpTotal += (unitMrp * item.quantity);
      calculatedSellingTotal += (unitPrice * item.quantity);
    });

    // Final Dynamic Values
    double mrpTotal = calculatedMrpTotal;

    // Price Discount = Total MRP - Total Selling Price
    double priceDiscount = calculatedMrpTotal - calculatedSellingTotal;
    if (priceDiscount < 0) priceDiscount = 0.0; // Safety check

    // Final Payable Amount (API ke main total par depend reh sakte hain ya calculated par)
    double totalToPay = cartProvider.cartTotals?.totalPrice ?? calculatedSellingTotal;

    double minimumOrderAmount = 1500.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Updated values here
          _buildDataRow("MRP Total :", "₹${mrpTotal.toStringAsFixed(2)}"),
          _buildDataRow(
            "Price Discount :",
            "- ₹${priceDiscount.toStringAsFixed(2)}",
            isGreen: priceDiscount > 0, // Discount hone par green dikhega
          ),
          _buildDataRow("Shipping Charges :", "As per delivery address"),

          const SizedBox(height: 5),
          if (!isPlaceOrderPage)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Minimum Order Amount :",
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w500, fontSize: 13),
                ),
                Text(
                  "₹${minimumOrderAmount.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),

          const Divider(thickness: 1, height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("To Pay", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                "₹${totalToPay.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A5ED3)),
              ),
            ],
          ),

          const SizedBox(height: 15),
          if (!isPlaceOrderPage)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("CONTINUE SHOPPING", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
            ),

          ElevatedButton(
            onPressed: totalToPay < minimumOrderAmount && !isPlaceOrderPage
                ? null
                : (onButtonClick ?? () {
              Get.to(() => PlaceOrderScreen(
                firmId: firmId,
                userId: userId,
                roleId: roleId,
                userTypeId: userTypeId,
                address: address,
                phoneno: phoneno,
                firmName: firmName,
              ));
            }),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A5ED3),
              disabledBackgroundColor: Colors.grey[300],
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: Text(
              isPlaceOrderPage
                  ? "PLACE ORDER"
                  : (totalToPay < minimumOrderAmount ? "MIN. ORDER ₹1500" : "CHECK OUT"),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String title, String value, {bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.black54, fontSize: 14)),
          Text(
            value,
            style: TextStyle(
                color: isGreen ? Colors.green : Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}