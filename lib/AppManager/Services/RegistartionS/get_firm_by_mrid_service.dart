import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/RegistrationM/get_firm_by_mrid_model.dart';

class GetFirmByMridService {

  Future<GetFirmByMridModel?> getFirmByMrId(int mrId) async {

    final uri = Uri.parse(
        "https://mrnew.medrpha.com/api/MasterApi/get-firm-by-mrid?mrId=$mrId");

    print("------------ API CALL ------------");
    print("URI: $uri");
    print("Request Body: mrId=$mrId");

    try {
      final response = await http.get(uri);

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return GetFirmByMridModel.fromJson(jsonDecode(response.body));
      }

    } catch (e) {
      print("API Error: $e");
    }

    return null;
  }
}