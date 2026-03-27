import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/AddtocartM/GetCartTotals_model.dart';

class GetCartTotalsService {
  static Future<GetCartTotalsModel?> getCartTotals({
    required int firmId,
    required int userTypeId,
  }) async {
    final String uri = 'https://mrnew.medrpha.com/api/Cart/GetCartTotals/$firmId/$userTypeId';
    print("URI: $uri");

    // Request body is empty for this API (all params are in path)
    final Map<String, dynamic> requestBody = {};
    print("Request Body: $requestBody");

    try {
      final response = await http.get(Uri.parse(uri));

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return GetCartTotalsModel.fromJson(data);
      } else {
        print("API Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception in GetCartTotalsService: $e");
      return null;
    }
  }
}