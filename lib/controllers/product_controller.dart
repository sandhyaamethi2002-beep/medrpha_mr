import 'package:get/get.dart';

// Product ka structure
class ProductModel {
  final String id;
  final String name;
  final String subtitle;
  final String company;
  final String image;

  ProductModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.company,
    required this.image,
  });
}

class ProductController extends GetxController {
  // Dummy data jo aapki image se match karta hai
  var allProducts = <ProductModel>[
    ProductModel(
      id: "1",
      name: "ASTHALIN RESPULES",
      subtitle: "ASTHALIN RESPULES",
      company: "Generic",
      image: "",
    ),
    ProductModel(
      id: "2",
      name: "1 AL TAB",
      subtitle: "just the testing 11111111111111111111111111111111111111111111111111",
      company: "Generic",
      image: "",
    ),
    ProductModel(
      id: "3",
      name: "ABELD D DDDD",
      subtitle: "AZILSARTAN MEDOXOMIL 40MG",
      company: "Generic",
      image: "",
    ),
  ].obs;

  // Search ke liye filtered list
  var filteredProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    filteredProducts.assignAll(allProducts);
  }

  void searchProduct(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(allProducts);
    } else {
      filteredProducts.assignAll(
        allProducts.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }
}