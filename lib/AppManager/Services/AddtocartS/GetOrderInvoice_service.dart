import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/AddtocartM/GetOrderInvoice_model.dart';


class GetOrderInvoiceService {

  Future<GetOrderInvoiceModel?> getOrderInvoice(int orderId) async {

    final uri = Uri.parse(
        "https://mrnew.medrpha.com/api/Cart/GetOrderInvoice/$orderId");

    print("------------ API CALL ------------");
    print("URI : $uri");
    print("REQUEST BODY : orderId = $orderId");

    try {

      final response = await http.get(uri);

      print("STATUS CODE : ${response.statusCode}");
      print("RESPONSE : ${response.body}");
      print("----------------------------------");

      if (response.statusCode == 200) {
        return GetOrderInvoiceModel.fromJson(json.decode(response.body));
      }

    } catch (e) {
      print("API ERROR : $e");
    }

    return null;
  }
}