import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/CategoryM/getByCategoryId_model.dart';


class GetByCategoryIdService {

  Future<GetByCategoryIdModel?> getProductsByCategory(String categoryId) async {

    try {

      final uri = Uri.parse(
          "https://mrnew.medrpha.com/api/MasterApi/GetByCategory/$categoryId");

      print("------------ API REQUEST ------------");
      print("URI : $uri");
      print("Request Body : categoryIds = $categoryId");

      final response = await http.get(uri);

      print("------------ API RESPONSE ------------");
      print("Status Code : ${response.statusCode}");
      print("Response Body : ${response.body}");

      if (response.statusCode == 200) {

        final jsonData = jsonDecode(response.body);

        return GetByCategoryIdModel.fromJson(jsonData);
      }

    } catch (e) {

      print("API ERROR : $e");

    }

    return null;
  }
}