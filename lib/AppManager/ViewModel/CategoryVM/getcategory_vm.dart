import 'package:get/get.dart';
import '../../Models/CategoryM/getcategory_model.dart';
import '../../Services/CategoryS/getCategory_service.dart';


class GetCategoryVM extends GetxController {

  var categoryList = <CategoryData>[].obs;
  var isLoading = false.obs;

  final GetCategoryService _service = GetCategoryService();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() async {
    try {
      isLoading(true);

      var data = await _service.getCategories();

      categoryList.assignAll(data);

    } catch (e) {
      print("Category Error : $e");
    } finally {
      isLoading(false);
    }
  }
}