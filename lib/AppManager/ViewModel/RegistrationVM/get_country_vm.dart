import 'package:get/get.dart';
import '../../Models/RegistrationM/get_country_model.dart';
import '../../Services/RegistartionS/get_country_service.dart';


class GetCountryVM extends GetxController {

  var isLoading = false.obs;
  var countryList = <CountryData>[].obs;
  var selectedCountry = Rxn<CountryData>();

  @override
  void onInit() {
    fetchCountries();
    super.onInit();
  }

  Future<void> fetchCountries() async {
    isLoading.value = true;

    final response = await GetCountryService.fetchCountries();

    if (response != null && response.success) {
      countryList.assignAll(response.data);
    }

    isLoading.value = false;
  }
}