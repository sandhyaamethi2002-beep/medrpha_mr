import 'dart:convert';
import 'package:http/http.dart' as http;

class GetOrdersByFirmService {
  static Future<List<dynamic>> getOrders({
    required int firmId,
    required String fromDate,
    required String toDate,
  }) async {
    final uri = Uri.parse(
        "https://mrnew.medrpha.com/api/Cart/GetOrdersByFirm/$firmId?fromDate=$fromDate&toDate=$toDate");

    // 🔥 PRINT URI
    print("API URI => $uri");

    try {
      final response = await http.get(uri);

      // 🔥 PRINT RESPONSE STATUS
      print("STATUS CODE => ${response.statusCode}");

      // 🔥 PRINT RESPONSE BODY
      print("RESPONSE BODY => ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        return jsonData['data'];
      } else {
        throw Exception("Failed to load orders");
      }
    } catch (e) {
      print("ERROR => $e");
      rethrow;
    }
  }
}