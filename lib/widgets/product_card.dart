import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../AppManager/Models/CategoryM/getProductDetail_model.dart';
import '../Provider/cart_provider.dart';
import '../Provider/saved_provider.dart';

class ProductCard extends StatelessWidget {
  final ProductData product;
  final bool isViewOnly;
  final int firmId;
  final int userId;

  const ProductCard({
    super.key,
    required this.product,
    this.isViewOnly = false,
    required this.firmId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<CartProvider, SavedProvider>(
      builder: (context, cart, savedProvider, _) {
        final String productId = product.pid.toString();
        final int quantity = cart.getProductQuantity(productId);
        final bool isSaved = savedProvider.isSaved(productId);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE SECTION
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F4F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: product.productImg != null
                      ? Image.network(
                    "https://mrnew.medrpha.com/uploads/${product.productImg}",
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Icon(
                      Icons.image_not_supported,
                      size: 30,
                      color: Colors.black26,
                    ),
                  )
                      : const Icon(
                    Icons.image_not_supported,
                    size: 30,
                    color: Colors.black26,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              /// DETAILS SECTION
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (product.productName ?? "N/A").toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),
                    Text(
                      "By ${product.companyName ?? "Unknown"}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.black54),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    /// --- NEW: MIN QTY & AVAILABLE QTY DISPLAY ---
                    Row(
                      children: [
                        // Min Qty Logic: Agar 0 hai toh 1 dikhao
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "Min: ${(int.tryParse(product.minQty.toString()) ?? 0) <= 0 ? 1 : product.minQty}",
                            style: TextStyle(color: Colors.orange.shade900, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Available Qty Logic: Agar 0 hai toh 1000 dikhao
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "Available: ${(int.tryParse(product.available_quantity.toString()) ?? 0) == 0 ? 1000 : product.available_quantity}",
                            style: TextStyle(color: Colors.green.shade900, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Text(
                          "₹${(product.finalCompanyPrice ?? 0).toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A5ED3),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              /// ACTION SECTION: Saved + Add/Quantity
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /// Saved icon
                  InkWell(
                    onTap: () => savedProvider.toggleSaveProduct(product),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: isSaved
                            ? const Color(0xFF1A5ED3)
                            : Colors.grey[400],
                        size: 22,
                      ),
                    ),
                  ),

                  /// Add to Cart / Quantity Controller
                  if (!isViewOnly)
                    SizedBox(
                      width: 95,
                      child: quantity == 0
                          ? _buildAddButton(cart)
                          : _buildQuantityController(context, cart, productId),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// ADD BUTTON
  Widget _buildAddButton(CartProvider cart) {
    int minQty = int.tryParse(product.minQty?.toString() ?? "1") ?? 1;

    if (minQty <= 0) {
      minQty = 1;
    }

    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: () {
          cart.updateQuantityManually(
            product: product,
            newQty: minQty,
            firmId: firmId ,
            userId: 1,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A5ED3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: const FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 14, color: Colors.white),
              Text(
                " Add",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// QUANTITY CONTROLLER (Updated with Keyboard Support)
  Widget _buildQuantityController(
      BuildContext context, CartProvider cart, String productId) {
    final int currentQty = cart.getProductQuantity(productId);

    int apiQty = int.tryParse(product.available_quantity.toString()) ?? 0;
    int minQty = int.tryParse(product.minQty.toString()) ?? 1;

    final int available_quantity = (apiQty == 0) ? 1000 : apiQty;

    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF1A5ED3), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
                cart.removeFromCart(productId, firmId: firmId, userId: userId);
            },
            child: const Icon(
                Icons.remove,
                size: 16,
                color: Color(0xFF1A5ED3)
            ),
          ),

          /// TAPPABLE QUANTITY FOR KEYBOARD INPUT
          InkWell(
            onTap: () => _showQuantityDialog(context, cart, currentQty, available_quantity),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                "$currentQty",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF1A5ED3)),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              if (currentQty < available_quantity) {
                cart.addToCart(
                  product: product,
                  firmId: firmId,
                  userId: userId,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Only $available_quantity units allowed.")),
                );
              }
            },
            child: Icon(
              Icons.add,
              size: 16,
              color: currentQty >= available_quantity ? Colors.grey : const Color(0xFF1A5ED3),
            ),
          ),
        ],
      ),
    );
  }

  /// DIALOG FOR MANUAL QUANTITY ENTRY
  void _showQuantityDialog(
      BuildContext context, CartProvider cart, int current, int max) {

    int minQty = int.tryParse(product.minQty.toString()) ?? 1;

    final TextEditingController controller =
    TextEditingController(text: current.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
            "Enter Quantity",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Min: $minQty, Max: $max",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.red)),
          ),

          ElevatedButton(
            onPressed: () {
              int? enteredValue = int.tryParse(controller.text);

              if (enteredValue != null && enteredValue > 0) {

                // 1. MINIMUM QUANTITY CHECK (Naya Logic)
                if (enteredValue < minQty) {
                  enteredValue = minQty; // Force set to minimum
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Minimum order quantity is $minQty"),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.orange,
                    ),
                  );
                }

                // 2. MAXIMUM QUANTITY CHECK
                else if (enteredValue > max) {
                  enteredValue = max;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Adjusted to maximum available: $max"),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }

                // Final Update call
                cart.updateQuantityManually(
                  product: product,
                  newQty: enteredValue,
                  firmId: firmId,
                  userId: userId,
                );
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A5ED3),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
            ),
            child: const Text("UPDATE"),
          ),
        ],
      ),
    );
  }

}