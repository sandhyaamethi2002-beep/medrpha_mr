import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/CategoryM/getcategory_model.dart';


class GetCategoryService {

  Future<List<CategoryData>> getCategories() async {

    final uri = Uri.parse(
        "https://mrnew.medrpha.com/api/MasterApi/GetCategories");

    print("----------- API CALL -----------");
    print("URI : $uri");
    print("Request Method : GET");

    final response = await http.get(uri);

    print("Status Code : ${response.statusCode}");
    print("Response Body : ${response.body}");
    print("--------------------------------");

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      GetCategoryModel model = GetCategoryModel.fromJson(jsonData);
      return model.data ?? [];
    } else {
      throw Exception("Failed to load categories");
    }
  }
}