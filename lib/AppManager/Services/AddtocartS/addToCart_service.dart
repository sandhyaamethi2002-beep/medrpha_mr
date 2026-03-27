import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/AddtocartM/addToCart_model.dart';

class AddToCartService {
  static const String baseUrl = "https://mrnew.medrpha.com/api/Cart/AddToCart";

  Future<AddToCartResponse?> addToCart({
    required int productId,
    required int firmId,
    required int userId,
    required int qty,
    required double unitPrice,
    required int wpid,
    required int priceId,
    required int userTypeId,
  }) async {
    final uri = Uri.parse(baseUrl);

    final body = {
      "productId": productId,
      "firmId": firmId,
      "userId": userId,
      "qty": qty,
      "unitPrice": unitPrice,
      "wpid": wpid,
      "priceId": priceId,
    };

    print("URI: $uri");
    print("Request Body: $body");

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return AddToCartResponse.fromJson(jsonDecode(response.body));
      } else {
        print("Error in API: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}