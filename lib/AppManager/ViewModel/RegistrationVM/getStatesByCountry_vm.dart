import 'package:get/get.dart';

import '../../Models/RegistrationM/getStatesByCountry_model.dart';
import '../../Services/RegistartionS/getStatesByCountry_service.dart';


class GetStatesByCountryVM extends GetxController {
  final GetStatesByCountryService _service =
  GetStatesByCountryService();

  var isLoading = false.obs;
  var stateList = <StateData>[].obs;
  var selectedState = Rxn<StateData>();

  Future<void> fetchStates(int countryId) async {
    try {
      isLoading.value = true;
      stateList.clear();

      final response = await _service.getStates(countryId);

      if (response != null && response.success) {
        stateList.assignAll(response.data);
      }
    } finally {
      isLoading.value = false;
    }
  }
}