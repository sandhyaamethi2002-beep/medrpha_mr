import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/CategoryM/getByCategoryId_model.dart';

class GetByCategoryService {

  Future<GetByCategoryModel?> getProductsByCategory() async {

    final uri = Uri.parse(
        "https://mrnew.medrpha.com/api/MasterApi/GetByCategory/6");

    print("----------- API CALL -----------");
    print("URI : $uri");
    print("REQUEST : categoryId = 6");

    try {

      final response = await http.get(uri);

      print("STATUS CODE : ${response.statusCode}");
      print("RESPONSE : ${response.body}");

      if (response.statusCode == 200) {
        return GetByCategoryModel.fromJson(
            jsonDecode(response.body));
      }

    } catch (e) {
      print("API ERROR : $e");
    }

    return null;
  }
}