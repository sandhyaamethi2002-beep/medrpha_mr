import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/AddtocartM/placeOrder_model.dart';

class PlaceOrderService {

  static const String url =
      "https://mrnew.medrpha.com/api/Cart/PlaceOrder";

  Future<PlaceOrderResponse?> placeOrder(
      PlaceOrderRequest request) async {

    try {

      print("------------ PLACE ORDER API ------------");

      Uri uri = Uri.parse(url);

      print("URI => $uri");
      print("REQUEST BODY => ${jsonEncode(request.toJson())}");

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(request.toJson()),
      );

      print("STATUS CODE => ${response.statusCode}");
      print("RESPONSE BODY => ${response.body}");

      if (response.statusCode == 200) {
        return PlaceOrderResponse.fromJson(jsonDecode(response.body));
      }

    } catch (e) {
      print("PLACE ORDER ERROR => $e");
    }

    return null;
  }
}