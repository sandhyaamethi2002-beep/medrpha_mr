import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/AddtocartM/GetOrderDetails_model.dart';

class GetOrderDetailsService {

  Future<GetOrderDetailsModel?> getOrderDetails(String orderId) async {

    final uri = Uri.parse(
        "https://mrnew.medrpha.com/api/Cart/GetOrderDetails/$orderId");

    print("-------------API CALL-------------");
    print("URI : $uri");
    print("Request OrderId : $orderId");

    try {

      final response = await http.get(uri);

      print("Status Code : ${response.statusCode}");
      print("Response : ${response.body}");

      if (response.statusCode == 200) {

        final jsonData = json.decode(response.body);

        return GetOrderDetailsModel.fromJson(jsonData);
      }

    } catch (e) {

      print("API ERROR : $e");

    }

    return null;
  }
}