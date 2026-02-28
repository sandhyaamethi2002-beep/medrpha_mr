import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/RegistrationM/get_country_model.dart';

class GetCountryService {

  static Future<GetCountryModel?> fetchCountries() async {
    final Uri url = Uri.parse(
        "https://retailer.medrpha.com/api/MasterApi/GetCountries");

    print("----------- API CALL -----------");
    print("URI: $url");
    print("Request Type: GET");

    try {
      final response = await http.get(url);

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print("--------------------------------");

      if (response.statusCode == 200) {
        return GetCountryModel.fromJson(
          jsonDecode(response.body),
        );
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}