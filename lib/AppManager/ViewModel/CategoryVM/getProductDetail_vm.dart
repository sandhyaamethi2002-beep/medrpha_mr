import 'package:get/get.dart';
import '../../Models/CategoryM/getProductDetail_model.dart';
import '../../Services/CategoryS/getProductDetail_service.dart';

class ProductDetailsViewModel extends GetxController {
  var isLoading = false.obs;
  var productList = <ProductData>[].obs;
  var allProducts = <ProductData>[].obs;
  var selectedCategory = "All".obs;

  final ProductDetailsService _service = ProductDetailsService();

  // MAPPING UPDATE: "All" ke liye saari IDs ka combination (1,2,3,4,5,6)
  final Map<String, String> categoryIdsMap = {
    "All": "1,2,3,4,5,6", // Sab categories ka data mangwane ke liye
    "Ayurvedic": "5",
    "Ethical": "1",
    "General": "6",
    "Generic": "2",
    "Surgical": "3",
    "Veterinary": "4",
  };

  @override
  void onInit() {
    super.onInit();
    // Shuruat mein saara data mangwa rahe hain
    filterByCategory("All");
  }

  void getProductDetails({
    String catId = '1,2,3,4,5,6',
    int adminId = 1,
    int userType = 1,
    int areaId = 1
  }) async {
    try {
      isLoading(true);

      // Console mein URL check karein, ab categoryIds=1,2,3,4,5,6 jayega
      var response = await _service.fetchProductDetails(
        categoryIds: catId,
        adminId: adminId,
        userTypeId: userType,
        areaId: areaId,
      );

      if (response != null && response.data != null) {
        allProducts.assignAll(response.data!);
        productList.assignAll(response.data!);
      } else {
        allProducts.clear();
        productList.clear();
      }
    } catch (e) {
      print("API ERROR: $e");
    } finally {
      isLoading(false);
    }
  }

  // --- UPDATED SEARCH LOGIC WITH TRIM ---
  void searchProduct(String query) {
    // Trim se aage-piche ke faltu spaces hat jayenge
    String cleanQuery = query.trim().toLowerCase();

    if (cleanQuery.isEmpty) {
      productList.assignAll(allProducts);
    } else {
      var filtered = allProducts.where((p) {
        // Product name aur company name dono ko check kar rahe hain
        String name = (p.productName ?? "").toLowerCase();
        String company = (p.companyName ?? "").toLowerCase();

        return name.contains(cleanQuery) || company.contains(cleanQuery);
      }).toList();

      productList.assignAll(filtered);
    }
  }

  // FILTER LOGIC
  void filterByCategory(String categoryName) {
    selectedCategory.value = categoryName;

    // Map se ID nikali (All ke liye ab "1,2,3,4,5,6" jayega)
    String targetId = categoryIdsMap[categoryName] ?? "1,2,3,4,5,6";

    print("---------------------------------");
    print("CATEGORY: $categoryName | SENDING IDs: $targetId");
    print("---------------------------------");

    // Fresh API hit
    getProductDetails(catId: targetId);
  }
}