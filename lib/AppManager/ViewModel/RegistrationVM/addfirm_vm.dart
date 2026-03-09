import 'package:get/get.dart';
import '../../Models/RegistrationM/addfirm_model.dart';
import '../../Services/RegistartionS/addfirm_service.dart';

class AddFirmVM extends GetxController {

  var isLoading = false.obs;

  Future<bool> addFirm({
    required Map<String, String> fields,
    required String dl1File,
    required String dl2File,
    required String pic3File,
  }) async {

    isLoading.value = true;

    AddFirmResponseModel? response = await AddFirmService.addFirm(
      fields: fields,
      dl1File: dl1File,
      dl2File: dl2File,
      pic3File: pic3File,
    );

    isLoading.value = false;

    if (response != null && response.success) {
      Get.snackbar("Success", response.message);
      return true;
    } else {
      Get.snackbar("Error", response?.message ?? "Something went wrong");
      return false;
    }
  }
}