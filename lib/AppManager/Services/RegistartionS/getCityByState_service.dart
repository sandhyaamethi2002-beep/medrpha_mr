import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/RegistrationM/getCityByState_model.dart';


class GetCityByStateService {
  Future<GetCityByStateModel?> getCityByState(int stateId) async {
    try {
      final uri = Uri.parse(
          "https://retailer.medrpha.com/api/MasterApi/GetCityByState?stateId=$stateId");

      print("🔵 URI: $uri");
      print("🟡 Request: stateId = $stateId");

      final response = await http.get(uri);

      print("🟢 Status Code: ${response.statusCode}");
      print("🟢 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return GetCityByStateModel.fromJson(jsonData);
      } else {
        print("API Error");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}