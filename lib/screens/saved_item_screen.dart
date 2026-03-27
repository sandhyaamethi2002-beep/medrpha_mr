import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../AppManager/Models/CategoryM/getProductDetail_model.dart';
import '../Provider/saved_provider.dart';
import '../Provider/cart_provider.dart';

class SavedItemsScreen extends StatelessWidget {
  final int firmId;
  final int userId;

  const SavedItemsScreen({
    super.key,
    required this.firmId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1A5ED3);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Saved Items",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<SavedProvider>(
        builder: (context, savedProvider, _) {
          if (savedProvider.savedItems.isEmpty) {
            return const Center(
              child: Text(
                "No saved items",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: savedProvider.savedItems.length,
            itemBuilder: (context, index) {
              final product = savedProvider.savedItems[index];

              final String imageUrl =
                  "https://mrnew.medrpha.com/uploads/${product.productImg ?? 'noimage.png'}";

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// IMAGE
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image, size: 22),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    /// DETAILS
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.productName ?? "N/A",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.description ?? "N/A",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "₹${product.finalCompanyPrice ?? 0}",
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// ACTIONS
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        /// DELETE BUTTON
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.grey, size: 24),
                          onPressed: () {
                            savedProvider.toggleSaveProduct(product);
                          },
                        ),
                        const SizedBox(height: 12),

                        /// MOVE TO CART
                        SizedBox(
                          height: 34,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              final cartProvider =
                              context.read<CartProvider>();

                              /// ADD TO CART with firmId & userId
                              await cartProvider.addToCart(
                                product: product,
                                firmId: firmId,
                                userId: userId,
                              );

                              /// REMOVE FROM SAVED
                              savedProvider.toggleSaveProduct(product);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Item moved to cart"),
                                  duration: Duration(seconds: 1),
                                  backgroundColor: primaryColor,
                                ),
                              );
                            },
                            child: const Text(
                              "Move to Cart",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}