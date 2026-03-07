import 'package:get/get.dart';
import '../../Models/CategoryM/getProductDetail_model.dart';
import '../../Services/CategoryS/getProductDetail_service.dart';

class ProductDetailViewModel extends GetxController {
  final ProductDetailService _service = ProductDetailService();
  var isLoading = false.obs;
  var productData = Rxn<ProductData>();

  Future<void> loadSingleProduct(String id) async {
    isLoading.value = true;

    productData.value = null;

    final result = await _service.fetchProductDetails(id);

    if (result != null && result.data != null && result.data!.isNotEmpty) {

      try {
        final matchedItem = result.data!.firstWhere(
              (item) => item.pid.toString() == id.toString(),
          orElse: () => result.data![0],
        );

        productData.value = matchedItem;
      } catch (e) {
        productData.value = result.data![0];
      }
    }

    isLoading.value = false;
  }
}