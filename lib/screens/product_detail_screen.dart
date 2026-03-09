import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../AppManager/ViewModel/CategoryVM/getProductDetail_vm.dart';
import '../controllers/product_controller.dart';
import '../Provider/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  final int categoryId;
  final int adminId;
  final int userTypeId;
  final int areaId;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.categoryId,
    required this.adminId,
    required this.userTypeId,
    required this.areaId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {

  late ProductDetailViewModel vm;

  @override
  void initState() {
    super.initState();

    /// Controller create with unique tag
    vm = Get.put(ProductDetailViewModel(), tag: widget.product.id);

    /// API CALL
    vm.loadSingleProduct(
      widget.product.id.toString(),
      widget.categoryId.toString(),
      widget.adminId.toString(),
      widget.userTypeId.toString(),
      widget.areaId.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {

    String imageUrl = widget.product.image;

    if (!imageUrl.startsWith('http')) {
      imageUrl = "https://mrnew.medrpha.com/uploads/$imageUrl";
    }

    return Scaffold(
      backgroundColor: Colors.white,

      /// APPBAR
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

      /// BODY
      body: Obx(() {

        if (vm.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF1A5ED3),
            ),
          );
        }

        final detail = vm.productData.value;

        /// PRICE LOGIC
        double displayPrice =
        (detail?.finalCompanyPrice != null && detail!.finalCompanyPrice! > 0)
            ? detail.finalCompanyPrice!
            : (widget.product.price ?? 0).toDouble();

        num displayMrp =
        (detail?.mrp != null && detail!.mrp! > 0)
            ? detail.mrp!
            : (widget.product.mrp ?? 0). toDouble();

        num displayDiscount =
        (detail?.discountPercentage != null &&
            detail!.discountPercentage! > 0)
            ? detail.discountPercentage!
            : (widget.product.discount ?? 0).toDouble();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// PRODUCT IMAGE
              Container(
                height: 300,
                width: double.infinity,
                color: Colors.grey[100],
                child: widget.product.image.isNotEmpty
                    ? Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported,
                      size: 100, color: Colors.grey),
                )
                    : const Icon(Icons.image_not_supported,
                    size: 100, color: Colors.grey),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// PRODUCT NAME
                    Text(
                      (detail?.productName ?? widget.product.name)
                          .toUpperCase(),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),

                    const SizedBox(height: 5),

                    /// COMPANY
                    Text(
                      (detail?.companyName ?? widget.product.company)
                          .toUpperCase(),
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500),
                    ),

                    const SizedBox(height: 20),

                    /// MRP
                    // if (displayMrp > 0)
                      Text(
                        "MRP: ₹ ${displayMrp.toStringAsFixed(2)}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),

                    const SizedBox(height: 6),

                    /// PRICE + DISCOUNT
                    Row(
                      children: [
                        Text(
                          "₹ ${displayPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),

                        const SizedBox(width: 12),

                        // if (displayDiscount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "${displayDiscount.toStringAsFixed(0)}% OFF",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    /// DESCRIPTION
                    const Text(
                      "Description",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      (detail?.description ?? widget.product.subtitle)
                          .toString()
                          .isEmpty
                          ? "No description available."
                          : (detail?.description ??
                          widget.product.subtitle),
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                          height: 1.5),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        );
      }),

      /// CART SECTION
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {

          int quantity =
          cartProvider.getProductQuantity(widget.product.id);

          return Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
              onPressed: () =>
                  cartProvider.addToCart(widget.product),
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
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color(0xFF1A5ED3), width: 1.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceAround,
                children: [

                  /// REMOVE
                  IconButton(
                    onPressed: () => cartProvider
                        .removeFromCart(widget.product.id),
                    icon: const Icon(Icons.remove,
                        color: Color(0xFF1A5ED3), size: 28),
                  ),

                  Text(
                    "$quantity",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),

                  /// ADD
                  IconButton(
                    onPressed: () =>
                        cartProvider.addToCart(widget.product),
                    icon: const Icon(Icons.add,
                        color: Color(0xFF1A5ED3), size: 28),
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