import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:medrpha_new/screens/cart_screen.dart';
import 'package:medrpha_new/screens/product_detail_screen.dart';
import '../AppManager/ViewModel/CategoryVM/getByCategoryId_vm.dart';
import '../AppManager/ViewModel/CategoryVM/getcategory_vm.dart';
import '../Provider/cart_provider.dart';
import '../controllers/product_controller.dart';
import '../widgets/category_filter.dart';
import '../widgets/product_card.dart';

class ProductScreen extends StatelessWidget {
  final String firmName;

  ProductScreen({super.key, required this.firmName});

  final GetCategoryVM categoryVM = Get.put(GetCategoryVM());
  final ProductController controller = Get.put(ProductController());
  final GetByCategoryIdVM productVM = Get.put(GetByCategoryIdVM());

  @override
  Widget build(BuildContext context) {
    /// FIRST LOAD
    if (productVM.productList.isEmpty) {
      productVM.fetchProducts("5", categoryName: "All");
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A5ED3),
        elevation: 0,
        title: Text(
          firmName.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, size: 26),
                onPressed: () => Get.to(() => const CartScreen()),
              ),
              Positioned(
                right: 5,
                top: 5,
                child: Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    return cart.totalItems == 0
                        ? const SizedBox()
                        : Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF1A5ED3), width: 1),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '${cart.totalItems}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: Column(
        children: [
          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => productVM.searchProduct(value),
                    decoration: InputDecoration(
                      hintText: "Search products...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                      ),
                      builder: (context) => CategoryFilter(
                        categoryVM: categoryVM,
                        productVM: productVM,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A5ED3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.tune, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          Obx(() {
            if (productVM.selectedCategoryName.value == "All") return const SizedBox();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Category : ${productVM.selectedCategoryName.value}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A5ED3),
                  ),
                ),
              ),
            );
          }),

          /// PRODUCT LIST
          Expanded(
            child: Obx(() {
              if (productVM.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (productVM.filteredList.isEmpty) {
                return const Center(child: Text("No Products Found"));
              }

              return ListView.builder(
                itemCount: productVM.filteredList.length,
                itemBuilder: (context, index) {
                  // productVM.filteredList se direct data le rahe hain
                  final apiData = productVM.filteredList[index];

                  // Mapping ProductData (API) to ProductModel (UI)
                  final uiProduct = ProductModel(
                    id: apiData.pid.toString(),
                    name: apiData.productName ?? "No Name",
                    subtitle: apiData.description ?? "No Description",
                    company: apiData.companyName ?? "Unknown Brand",
                    // Agar image URL incomplete hai toh base URL yahan add karein
                    image: apiData.productImg ?? "",
                    category: apiData.categoryName ?? "",
                    type: apiData.productType ?? "",
                    // Agar aapne ProductModel mein niche ke fields add kiye hain:
                    // mrp: apiData.mrp,
                    // price: apiData.finalCompanyPrice,
                    // discount: apiData.discountPercentage,
                  );

                  return InkWell(
                    onTap: () {
                      // Ab sahi 'uiProduct' pass ho raha hai
                      Get.to(() => ProductDetailScreen(product: uiProduct));
                    },
                    child: ProductCard(product: uiProduct),
                  );
                },
              );
            }),
          )
        ],
      ),
    );
  }
}