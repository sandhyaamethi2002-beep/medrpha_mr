import 'dart:convert';
import 'package:http/http.dart' as http;

class GetMrByIdService {
  Future<Map<String, dynamic>?> getMrById(int mrId) async {
    try {
      final uri = Uri.parse(
          "https://mrnew.medrpha.com/api/MasterApi/get-mr-by-id?mrId=$mrId");

      print(" URI: $uri");
      print(" Request: mrId = $mrId");

      final response = await http.get(uri);

      print(" Status Code: ${response.statusCode}");
      print(" Response: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
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