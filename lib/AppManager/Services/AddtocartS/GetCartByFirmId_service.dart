import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/AddtocartM/GetCartByFirmId_model.dart';

class GetCartByFirmIdService {
  static Future<GetCartByFirmIdResponse?> getCart({
    required int firmId,
    required int userTypeId
  }) async {
    final uri = Uri.parse('https://mrnew.medrpha.com/api/Cart/GetCartByFirmId/$firmId/$userTypeId');

    print("===== GET CART API =====");
    print("URI: $uri");
    print("Request Body: {} (no body, path params used)");

    try {
      final response = await http.get(uri);

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return GetCartByFirmIdResponse.fromJson(jsonData);
      } else {
        print("Error fetching cart");
      }
    } catch (e) {
      print("Exception: $e");
    }
    return null;
  }
}