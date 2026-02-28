import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/RegistrationM/getPincodeByCity_model.dart';

class GetPincodeByCityService {

  Future<GetPincodeByCityModel?> getPincodeByCity(int cityId) async {
    try {
      final uri = Uri.parse(
        "https://retailer.medrpha.com/api/MasterApi/GetAreaByCity?cityId=$cityId",
      );

      print(" URI: $uri");

      print(" Request Query: cityId = $cityId");

      final response = await http.get(uri);

      print(" Status Code: ${response.statusCode}");

      print(" Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return GetPincodeByCityModel.fromJson(jsonData);
      } else {
        print(" API Error");
        return null;
      }
    } catch (e) {
      print(" Exception: $e");
      return null;
    }
  }
}