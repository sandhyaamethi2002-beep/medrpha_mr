import 'package:get/get.dart';
import '../../Models/CategoryM/getByCategoryId_model.dart';
import '../../Services/CategoryS/getByCategoryId_service.dart';

class GetByCategoryIdVM extends GetxController {

  /// LOADING
  var isLoading = false.obs;

  /// PRODUCT LISTS
  var productList = <ProductData>[].obs;
  var filteredList = <ProductData>[].obs;

  /// ⭐ SELECTED CATEGORY
  var selectedCategoryId = "".obs;
  var selectedCategoryName = "All".obs;

  final GetByCategoryIdService service = GetByCategoryIdService();

  /// --- FETCH PRODUCTS ---
  Future<void> fetchProducts(
      String categoryId, {
        String categoryName = "All",
      }) async {

    try {
      isLoading.value = true;

      /// CATEGORY UPDATE
      selectedCategoryId.value = categoryId;
      selectedCategoryName.value = categoryName;

      final response = await service.getProductsByCategory(categoryId);

      if (response != null && response.success == true) {
        productList.assignAll(response.data ?? []);
        filteredList.assignAll(response.data ?? []);
      } else {
        productList.clear();
        filteredList.clear();
      }

    } catch (e) {
      print("VM ERROR : $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// --- SEARCH LOGIC ---
  void searchProduct(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(productList);
    } else {
      var results = productList.where((product) {
        final productName = product.productName?.toLowerCase() ?? "";
        return productName.contains(query.toLowerCase());
      }).toList();

      filteredList.assignAll(results);
    }
  }
}