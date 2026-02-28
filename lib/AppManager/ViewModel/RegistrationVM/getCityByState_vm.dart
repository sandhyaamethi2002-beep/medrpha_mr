import 'package:get/get.dart';
import '../../Models/RegistrationM/getCityByState_model.dart';
import '../../Services/RegistartionS/getCityByState_service.dart';

class GetCityByStateVM extends GetxController {
  final GetCityByStateService _service = GetCityByStateService();

  var isLoading = false.obs;
  var cityList = <CityData>[].obs;
  var selectedCity = Rxn<CityData>();

  Future<void> fetchCities(int stateId) async {
    try {
      isLoading.value = true;

      final response = await _service.getCityByState(stateId);

      if (response != null && response.success) {
        cityList.assignAll(response.data);
      } else {
        cityList.clear();
      }
    } catch (e) {
      print(" VM Error: $e");
      cityList.clear();
    } finally {
      isLoading.value = false;
    }
  }
}