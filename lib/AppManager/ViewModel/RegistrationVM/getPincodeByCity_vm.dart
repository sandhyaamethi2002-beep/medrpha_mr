import 'package:get/get.dart';

import '../../Models/RegistrationM/getPincodeByCity_model.dart';
import '../../Services/RegistartionS/getPincodeByCity_service.dart';


class GetPincodeByCityVM extends GetxController {
  final GetPincodeByCityService _service = GetPincodeByCityService();

  var isLoading = false.obs;
  var areaList = <AreaData>[].obs;
  var selectedArea = Rxn<AreaData>();   // 👈 IMPORTANT

  Future<void> fetchPincode(int cityId) async {
    try {
      isLoading.value = true;

      final response = await _service.getPincodeByCity(cityId);

      if (response != null && response.success) {
        areaList.value = response.data;

        if (areaList.isNotEmpty) {
          selectedArea.value = areaList.first; // default select
        }
      }
    } catch (e) {
      print("VM Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}