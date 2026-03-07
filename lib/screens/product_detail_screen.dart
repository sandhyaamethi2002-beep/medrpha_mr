import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../AppManager/ViewModel/CategoryVM/getProductDetail_vm.dart';
import '../controllers/product_controller.dart';
import '../Provider/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Unique tag use kiya hai taaki sahi product ka data load ho
    final ProductDetailViewModel vm = Get.put(ProductDetailViewModel(), tag: product.id);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.loadSingleProduct(product.id);
    });

    String imageUrl = product.image;
    if (!imageUrl.startsWith('http')) {
      imageUrl = "https://mrnew.medrpha.com/uploads/$imageUrl";
    }

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
          "Product Detail",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (vm.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF1A5ED3),
            ),
          );
        }

        final detail = vm.productData.value;

        // Data priority logic
        double displayPrice = detail?.finalCompanyPrice ?? product.price ?? 0;
        double displayMrp = detail?.mrp ?? product.mrp ?? 0.0;
        double displayDiscount = detail?.discountPercentage ?? product.discount ?? 0.0;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// PRODUCT IMAGE
              Container(
                height: 300,
                width: double.infinity,
                color: Colors.grey[100],
                child: product.image.isNotEmpty
                    ? Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                )
                    : const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 1. NAME & COMPANY
                    Text(
                      (detail?.productName ?? product.name).toUpperCase(),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      (detail?.companyName ?? product.company).toUpperCase(),
                      style: TextStyle(fontSize: 15, color: Colors.grey[600], fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 20),

                    /// 2. PRICING SECTION
                    if (displayMrp > 0)
                      Text(
                        "MRP: ₹ ${displayMrp.toStringAsFixed(2)}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),

                    Row(
                      children: [
                        Text(
                          "₹ ${displayPrice.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(width: 12),

                        if (displayDiscount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "${displayDiscount.toStringAsFixed(0)}% OFF",
                              style: TextStyle(fontSize: 16, color: Colors.green[700], fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    /// DESCRIPTION
                    const Text(
                      "Description",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      (detail?.description ?? product.subtitle).isEmpty
                          ? "No description available."
                          : (detail?.description ?? product.subtitle),
                      style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.5),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          int quantity = cartProvider.getProductQuantity(product.id);

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 2)
              ],
              border: const Border(top: BorderSide(color: Colors.black12, width: 0.5)),
            ),
            child: quantity == 0
                ? ElevatedButton(
              onPressed: () => cartProvider.addToCart(product),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A5ED3),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
              child: const Text(
                "Add to Cart",
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
                : Container(
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF1A5ED3), width: 1.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () => cartProvider.removeFromCart(product.id),
                    icon: const Icon(Icons.remove, color: Color(0xFF1A5ED3), size: 28),
                  ),
                  Text(
                    "$quantity",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => cartProvider.addToCart(product),
                    icon: const Icon(Icons.add, color: Color(0xFF1A5ED3), size: 28),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}