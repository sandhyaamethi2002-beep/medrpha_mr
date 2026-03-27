import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medrpha_new/screens/myorder_screen.dart';
import 'package:medrpha_new/widgets/add_user_screen.dart';
import 'package:provider/provider.dart';
import 'package:medrpha_new/screens/product_detail_screen.dart';
import 'package:medrpha_new/screens/saved_item_screen.dart';
import 'package:medrpha_new/widgets/product_card2.dart';
import '../AppManager/ViewModel/CategoryVM/getByCategoryId_vm.dart';
import '../AppManager/ViewModel/CategoryVM/getProductDetail_vm.dart';
import '../Provider/cart_provider.dart';
import '../widgets/category_filter.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';

class ProductScreen extends StatelessWidget {
  final String firmName;
  final int firmId;
  final int userId;
  final int roleId;
  final int userTypeId;
  final String? address;
  final String? phoneno;
  final bool isViewOnly;
  final bool isSearch;

  const ProductScreen({
    super.key,
    required this.firmName,
    required this.firmId,
    required this.userId,
    required this.roleId,
    required this.userTypeId,
    this.phoneno,
    this.address,
    this.isViewOnly = false,
    this.isSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    print("DEBUG: ProductScreen received userId: $userId, firmId: $firmId");

    return isViewOnly
        ? ChangeNotifierProvider(
      create: (_) => GetByCategoryVM(),
      child: _ProductScreenBody(
        firmName: firmName,
        firmId: firmId,
        userId: userId,
        roleId: roleId,
        userTypeId: userTypeId,
        address: address,
        phoneno: phoneno,
        isViewOnly: true,
        isSearch: isSearch,
      ),
    )
        : _ProductScreenBody(
      firmName: firmName,
      firmId: firmId,
      userId: userId,
      roleId: roleId,
      userTypeId: userTypeId,
      isViewOnly: false,
      isSearch: isSearch,
      address: address,
      phoneno: phoneno,
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  final String firmName;
  final int firmId;
  final int userId;
  final int roleId;
  final int userTypeId;
  final bool isViewOnly;
  final bool isSearch;
  final String? address;
  final String? phoneno;

  _ProductScreenBody({
    super.key,
    required this.firmName,
    required this.firmId,
    required this.userId,
    required this.roleId,
    required this.userTypeId,
    required this.isViewOnly,
    required this.isSearch,
    this.address,
    this.phoneno,
  });

  final ProductDetailsViewModel activeVM = Get.put(ProductDetailsViewModel());
  final GetByCategoryVM categoryVM = Get.put(GetByCategoryVM());

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    if (isViewOnly) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final vm = context.read<GetByCategoryVM>();
        if (vm.productList.isEmpty) vm.fetchProducts();
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A5ED3),
        elevation: 0,
        // 1. Title ki width thodi aur kam ki taaki buttons ko space mile
        title: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: screenWidth * 0.35),
          child: Text(
            firmName.toUpperCase(),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15, // Size thoda kam kiya
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (isSearch)
          // 2. Registration button ko Flexible wrap kiya taaki overflow na ho
            Flexible(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SizedBox(
                    height: 28, // Height optimize ki
                    child: ElevatedButton(
                      onPressed: () {
                        print("Passing Phone to Registration: $phoneno");
                        Get.to(() => AddUserScreen(phoneNumber: phoneno));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1A5ED3),
                        padding: const EdgeInsets.symmetric(horizontal: 6), // Inner padding kam ki
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        "Complete Registration",
                        maxLines: 1,
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          if (!isSearch) ...[
            // 3. IconButton mein visualDensity ka use kiya extra padding hatane ke liye
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(CupertinoIcons.cube_box, size: 20),
              onPressed: () {
                print("Navigating to MyOrders with Firm ID: $firmId");
                Get.to(() => MyOrdersScreen(firmId: firmId));
              },
            ),
            const SizedBox(width: 4), // Gap kam kiya
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.bookmark_border, size: 22),
              onPressed: () => Get.to(() => SavedItemsScreen(
                firmId: firmId,
                userId: userId,
              )),
            ),
          ],

          if (!isViewOnly)
            Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 6.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.shopping_cart_outlined, size: 22),
                    onPressed: () {
                      print("NAVIGATION userId: $userId");
                      Get.to(() => CartScreen(
                        firmId: firmId,
                        userId: userId,
                        roleId: roleId,
                        userTypeId: userTypeId,
                        address: address,
                        phoneno: phoneno,
                        firmName: firmName,
                      ));
                    },
                  ),
                  Positioned(
                    right: -4,
                    top: 8,
                    child: Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        if (cart.totalItems == 0) return const SizedBox();
                        return Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                          child: Text(
                            "${cart.totalItems}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          const SizedBox(width: 2), // Last padding kam ki
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // SEARCH BAR
            if (!isSearch)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: isViewOnly
                          ? Consumer<GetByCategoryVM>(
                        builder: (context, vm, child) {
                          return TextField(
                            onChanged: (value) => vm.searchProduct(value),
                            decoration: InputDecoration(
                              hintText: "Search products...",
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              contentPadding: const EdgeInsets.symmetric(vertical: 0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          );
                        },
                      )
                          : TextField(
                        onChanged: (value) => activeVM.searchProduct(value),
                        decoration: InputDecoration(
                          hintText: "Search products...",
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    if (!isViewOnly) ...[
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => Get.bottomSheet(
                          const CategoryFilter(),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A5ED3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.tune, color: Colors.white, size: 22),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

            // PRODUCT LIST
            Expanded(
              child: isViewOnly
                  ? Consumer<GetByCategoryVM>(
                builder: (context, vm, child) {
                  if (vm.isLoading) return const Center(child: CircularProgressIndicator());
                  if (vm.productList.isEmpty) return const Center(child: Text("No Products Found"));
                  return ListView.builder(
                    itemCount: vm.productList.length,
                    itemBuilder: (context, index) {
                      final product = vm.productList[index];
                      return ProductCard2(
                        product: product,
                        firmId: firmId,
                        userId: userId,
                      );
                    },
                  );
                },
              )
                  : Obx(() {
                if (activeVM.isLoading.value) return const Center(child: CircularProgressIndicator());
                if (activeVM.productList.isEmpty) return const Center(child: Text("No Products Found"));
                return ListView.builder(
                  itemCount: activeVM.productList.length,
                  itemBuilder: (context, index) {
                    final product = activeVM.productList[index];
                    return InkWell(
                      onTap: () => Get.to(() => ProductDetailScreen(
                        product: product,
                        firmId: firmId,
                        userId: userId,
                      )),
                      child: ProductCard(
                        product: product,
                        isViewOnly: false,
                        firmId: firmId,
                        userId: userId,
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}