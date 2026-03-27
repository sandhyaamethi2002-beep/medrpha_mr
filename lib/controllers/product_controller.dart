import 'package:get/get.dart';

class ProductModel {
  final String id;
  final String name;
  final String subtitle;
  final String company;
  final String image;
  final String categoryId;
  final String type;
  final double? mrp;
  final double? price;
  final double? discount;

  ProductModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.company,
    required this.image,
    required this.categoryId,
    required this.type,
    this.mrp,
    this.price,
    this.discount,
  });
}

class ProductController extends GetxController {
  // Original List (Mock Data)
  var allProducts = <ProductModel>[].obs;

  // List jo UI pe dikhegi (Filtered)
  var filteredProducts = <ProductModel>[].obs;

  var searchQuery = "".obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyProducts(); // Initial data load
  }

  /// DUMMY DATA LOAD (API ki jagah)
  void loadDummyProducts() {
    isLoading.value = true;

    // Fake delay taaki loading effect dikhe
    Future.delayed(const Duration(seconds: 1), () {
      var dummyData = List.generate(10, (index) => ProductModel(
        id: index.toString(),
        name: "Medicine Name $index",
        subtitle: "Composition details here",
        company: "Pharma Co $index",
        image: "https://via.placeholder.com/150",
        categoryId: "Category $index",
        type: "Tablet",
        mrp: 500.0,
        price: 450.0,
        discount: 10.0,
      ));

      allProducts.assignAll(dummyData);
      filteredProducts.assignAll(dummyData);
      isLoading.value = false;
    });
  }

  /// SEARCH PRODUCT LOGIC
  void searchProduct(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredProducts.assignAll(allProducts);
    } else {
      var results = allProducts.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.company.toLowerCase().contains(query.toLowerCase());
      }).toList();

      filteredProducts.assignAll(results);
    }
  }

  /// CATEGORY FILTER (UI ONLY)
  void filterByCategory(String categoryId) {
    if (categoryId == "All") {
      filteredProducts.assignAll(allProducts);
    } else {
      var results = allProducts.where((p) => p.categoryId == categoryId).toList();
      filteredProducts.assignAll(results);
    }
  }
}