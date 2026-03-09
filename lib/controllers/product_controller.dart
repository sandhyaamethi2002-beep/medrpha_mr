import 'package:get/get.dart';
import '../AppManager/ViewModel/CategoryVM/getByCategoryId_vm.dart';

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
  // Get.find ki jagah Get.put use karein agar error aa raha hai
  // Ya phir ensure karein ki VM pehle initialize ho chuka ho
  final GetByCategoryIdVM apiVM = Get.put(GetByCategoryIdVM());

  var filteredProducts = <ProductModel>[].obs;
  var searchQuery = "".obs;

  /// LOAD PRODUCTS BY CATEGORY
  Future<void> loadProductsByCategory(String categoryId) async {
    await apiVM.fetchProducts(categoryId);
    _mapApiToUi();
  }

  /// Helper to convert API Data to UI Model
  void _mapApiToUi() {
    final products = apiVM.productList.map((e) {
      return ProductModel(
        id: e.pid.toString(),
        name: e.productName ?? "",
        subtitle: e.description ?? "",
        company: e.companyName ?? "Unknown",
        image: e.productImg ?? "",
        categoryId: e.categoryName ?? "",
        type: e.productType ?? "",
        // VM ke ProductData se fields utha rahe hain
        mrp: e.mrp?.toDouble() ?? 0.0,
        price: e.finalCompanyPrice?.toDouble() ?? 0.0,
        discount: e.discountPercentage?.toDouble() ?? 0.0,
      );
    }).toList();

    filteredProducts.assignAll(products);
  }

  /// SEARCH PRODUCT
  void searchProduct(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      _mapApiToUi();
      return;
    }

    var results = apiVM.productList.where((product) {
      final name = product.productName ?? "";
      return name.toLowerCase().contains(query.toLowerCase());
    }).map((e) {
      return ProductModel(
        id: e.pid.toString(),
        name: e.productName ?? "",
        subtitle: e.description ?? "",
        company: e.companyName ?? "Unknown",
        image: e.productImg ?? "",
        categoryId: e.categoryName ?? "",
        type: e.productType ?? "",
        mrp: e.mrp,
        price: e.finalCompanyPrice,
        discount: e.discountPercentage,
      );
    }).toList();

    filteredProducts.assignAll(results);
  }
}