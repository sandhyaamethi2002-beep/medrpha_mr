import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/RegistrationM/getStatesByCountry_model.dart';

class GetStatesByCountryService {
  Future<GetStatesByCountryModel?> getStates(int countryId) async {
    try {
      final uri = Uri.parse(
          "https://retailer.medrpha.com/api/MasterApi/GetStatesByCountry?countryId=$countryId");

      print("===== GET STATES API =====");
      print("URI: $uri");
      print("Request Query: countryId=$countryId");

      final response = await http.get(uri);

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return GetStatesByCountryModel.fromJson(jsonData);
      }
    } catch (e) {
      print("Error in getStates API: $e");
    }
    return null;
  }
}