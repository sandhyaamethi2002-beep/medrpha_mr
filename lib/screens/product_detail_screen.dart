import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../AppManager/Models/CategoryM/getProductDetail_model.dart';
import '../Provider/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductData product;
  final int firmId; // dynamic firmId
  final int userId; // dynamic userId

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.firmId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        "https://mrnew.medrpha.com/uploads/${product.productImg ?? "noimage.png"}";

    double calcDiscount = 0;
    if ((product.mrp ?? 0) > (product.finalCompanyPrice ?? 0)) {
      calcDiscount =
          ((product.mrp! - product.finalCompanyPrice!) / product.mrp!) * 100;
    }

    double finalDiscount = (product.discount != null && product.discount! > 0)
        ? product.discount!
        : calcDiscount;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A5ED3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "PRODUCT DETAIL",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[100],
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_not_supported,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (product.productName ?? "N/A").toUpperCase(),
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    (product.companyName ?? "Unknown Company").toUpperCase(),
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "MRP: ₹ ${(product.mrp ?? 0).toStringAsFixed(2)}",
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        "₹ ${(product.finalCompanyPrice ?? 0).toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(width: 20),
                      if (finalDiscount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "${finalDiscount.toStringAsFixed(0)}% OFF",
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.description == null || product.description!.isEmpty
                        ? "No description available."
                        : product.description!,
                    style: TextStyle(
                        fontSize: 16, color: Colors.grey[800], height: 1.6),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),

      /// BOTTOM NAVIGATION BAR WITH MANUAL QUANTITY SUPPORT
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          String productId = product.pid.toString();
          int quantity = cartProvider.getProductQuantity(productId);

          int apiQty = int.tryParse(product.available_quantity.toString()) ?? 0;
          int effectiveLimit = (apiQty == 0) ? 1000 : (apiQty > 1000 ? 1000 : apiQty);

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 2)
              ],
              border: const Border(
                  top: BorderSide(color: Colors.black12, width: 0.5)),
            ),
            child: quantity == 0
                ? ElevatedButton(
              onPressed: () async {
                // Pehli baar add karne par
                await cartProvider.addToCart(
                    product: product, firmId: firmId, userId: userId);

                // --- SAFETY CHECK ---
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Added to cart!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A5ED3),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
              child: const Text(
                "Add to Cart",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            )
                : Container(
              height: 55,
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color(0xFF1A5ED3), width: 1.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  /// DECREASE BUTTON
                  IconButton(
                    onPressed: () async {
                      await cartProvider.removeFromCart(productId,
                          firmId: firmId, userId: userId);
                    },
                    icon: const Icon(Icons.remove,
                        color: Color(0xFF1A5ED3), size: 28),
                  ),

                  /// MANUAL INPUT
                  InkWell(
                    onTap: () => _showQuantityDialog(
                        context, cartProvider, quantity, effectiveLimit),
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "$quantity",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  /// INCREASE BUTTON (Yahan bhi fix kar diya hai)
                  IconButton(
                    onPressed: () async {
                      if (quantity < effectiveLimit) {
                        await cartProvider.addToCart(
                            product: product,
                            firmId: firmId,
                            userId: userId);

                        // --- SAFETY CHECK ---
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Quantity updated!")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Max limit $effectiveLimit reached")),
                        );
                      }
                    },
                    icon: Icon(Icons.add,
                        color: quantity >= effectiveLimit ? Colors.grey : const Color(0xFF1A5ED3),
                        size: 28),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// DIALOG FOR MANUAL QUANTITY INPUT
  void _showQuantityDialog(
      BuildContext context, CartProvider cart, int current, int max) {
    final TextEditingController controller =
    TextEditingController(text: current.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Quantity"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Enter value (Max: $max)",
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              int? val = int.tryParse(controller.text);
              if (val != null && val > 0) {
                if (val > max) val = max;

                cart.updateQuantityManually(
                  product: product,
                  newQty: val,
                  firmId: firmId,
                  userId: userId,
                );
              }
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
}