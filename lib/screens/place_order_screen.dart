import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../AppManager/Models/AddtocartM/placeOrder_model.dart';
import '../AppManager/ViewModel/AddtocartVM/GetOrdersByFirm_vm.dart';
import '../AppManager/ViewModel/AddtocartVM/placeOrder_vm.dart';
import '../Provider/cart_provider.dart';
import '../widgets/bill_summary_widget.dart'; // Apna widget import karein
import 'add_new_address.dart';
import 'myorder_screen.dart';

class PlaceOrderScreen extends StatefulWidget {
  final int firmId;
  final int userId;
  final int roleId;
  final int userTypeId;
  final String? address;
  final String? phoneno;
  final String? firmName;

  const PlaceOrderScreen({
    super.key,
    required this.firmId,
    required this.userId,
    required this.roleId,
    required this.userTypeId,
    this.address,
    this.phoneno,
    this.firmName,
  });

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final Color primaryColor = const Color(0xFF1A5ED3);
  bool _isApiLoading = false;
  int _selectedPayment = 2; // 1: COD, 2: Online UPI
  String _selectedUpiApp = "G-Pay";

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: !_isApiLoading);
    final totals = cartProvider.cartTotals;

    // Calculation logic for final amount
    double totalPrice = totals?.totalPrice ?? 0.0;
    double handlingFee = totalPrice > 0 ? 20.0 : 0.0;
    double gst = totalPrice * 0.05;
    double finalPay = totalPrice + handlingFee + gst;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "PLACE ORDER",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              _sectionHeader("Delivery Address"),
              const SizedBox(height: 12),
              _buildAddressCard(),
              const SizedBox(height: 25),
              _sectionHeader("Payment Method"),
              const SizedBox(height: 12),
              _buildPaymentMethodSection(),
              if (_selectedPayment == 2) _buildUPIAppsGrid(),
              const SizedBox(height: 25),

              // Note: Yahan se purana manual _buildBillSummaryCard hata diya gaya hai
              // Kyunki ab BillSummaryWidget bottom navigation bar mein hai

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      // Yahan humne aapka updated BillSummaryWidget use kiya hai
      bottomNavigationBar: BillSummaryWidget(
        firmId: widget.firmId,
        userId: widget.userId,
        roleId: widget.roleId,
        userTypeId: widget.userTypeId,
        address: widget.address,
        phoneno: widget.phoneno,
        firmName: widget.firmName ?? "",
        isPlaceOrderPage: true, // Taki button "PLACE ORDER" dikhe
        onButtonClick: () => _handlePlaceOrder(finalPay), // API call function
      ),
    );
  }

  // --- API Logic Function ---
  Future<void> _handlePlaceOrder(double finalPay) async {
    if (_isApiLoading) return;

    setState(() => _isApiLoading = true);
    final placeOrderVM = Provider.of<PlaceOrderVM>(context, listen: false);

    try {
      PlaceOrderRequest request = PlaceOrderRequest(
        userId: widget.userId,
        userTypeId: widget.userTypeId,
        roleId: widget.roleId,
        orderAmount: finalPay,
        payModeId: _selectedPayment,
        transactionId: "TXN${DateTime.now().millisecondsSinceEpoch}",
        paymentStatus: _selectedPayment == 1 ? 0 : 1,
        address: widget.address ?? "No Address",
        country: "India",
        state: "UP",
        city: "Aligarh",
        phone: widget.phoneno ?? "",
        email: "test@gmail.com",
        name: widget.firmName ?? "No Name",
      );

      final response = await placeOrderVM.placeOrder(request);

      if (response != null && response.success) {
        final ordersVM = Get.put(GetOrdersByFirmVM());
        String today = DateFormat("yyyy-MM-dd").format(DateTime.now());

        ordersVM.fetchOrders(
          firmId: widget.firmId,
          fromDate: "2026-01-01",
          toDate: today,
        );

        Get.snackbar("Success", "Order Placed Successfully!",
            backgroundColor: Colors.green, colorText: Colors.white);

        Get.offAll(() => MyOrdersScreen(firmId: widget.firmId));
      } else {
        setState(() => _isApiLoading = false);
        Get.snackbar("Error", response?.message ?? "Failed to place order");
      }
    } catch (e) {
      setState(() => _isApiLoading = false);
      print("Error placing order: $e");
    }
  }

  // --- UI Components ---

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade50),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
            child: const Icon(Icons.location_on, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.firmName ?? "No Firm Name",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                    widget.address ?? "Address not provided",
                    style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.4)
                ),
                const SizedBox(height: 4),
                Text(
                    widget.phoneno ?? "No Phone Number",
                    style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.4)
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              showAddAddressBottomSheet(context);
            },
            child: Text("Edit", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      children: [
        _paymentOption(id: 1, title: "Cash on Delivery", subtitle: "Pay when you receive", icon: Icons.payments_outlined),
        const SizedBox(height: 12),
        _paymentOption(id: 2, title: "Online UPI / Wallet", subtitle: "Secure & Instant", icon: Icons.account_balance_wallet_outlined),
      ],
    );
  }

  Widget _paymentOption({required int id, required String title, required String subtitle, required IconData icon}) {
    bool isSelected = _selectedPayment == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = id),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? primaryColor : Colors.grey.shade200, width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: isSelected ? const Color(0xFFE3F2FD) : Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: isSelected ? primaryColor : Colors.grey),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Icon(isSelected ? Icons.check_circle : Icons.radio_button_unchecked, color: isSelected ? primaryColor : Colors.grey.shade300),
          ],
        ),
      ),
    );
  }

  Widget _buildUPIAppsGrid() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(color: const Color(0xFFF8FBFF), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.blue.shade50)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _upiAppItem("G-Pay", "assets/UPI/gpay.jpeg"),
          _upiAppItem("PhonePe", "assets/UPI/phonepe.png"),
          _upiAppItem("Paytm", "assets/UPI/paytm.png"),
        ],
      ),
    );
  }

  Widget _upiAppItem(String label, String assetPath) {
    bool isAppSelected = _selectedUpiApp == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedUpiApp = label),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: isAppSelected ? primaryColor : Colors.grey.shade300,
                  width: 2
              ),
              boxShadow: isAppSelected ? [BoxShadow(color: primaryColor.withOpacity(0.1), blurRadius: 4)] : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                assetPath,
                width: 45,
                height: 45,
                errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.grey,
                    size: 30
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
              label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: isAppSelected ? FontWeight.bold : FontWeight.normal,
                  color: isAppSelected ? primaryColor : Colors.black87
              )
          ),
        ],
      ),
    );
  }
}