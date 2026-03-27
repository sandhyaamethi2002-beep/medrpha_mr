import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../Models/CategoryM/getProductDetail_model.dart';

class ProductDetailsService {
  Future<ProductDetailsModel?> fetchProductDetails({
    required String categoryIds,
    required int adminId,
    required int userTypeId,
    required int areaId,
  }) async {
    final Map<String, String> queryParameters = {
      'categoryIds': categoryIds,
      'adminId': adminId.toString(),
      'userTypeId': userTypeId.toString(),
      'areaId': areaId.toString(),
    };

    final uri = Uri.https(
        'mrnew.medrpha.com', '/api/MasterApi/GetProductDetails', queryParameters);

    // --- URI PRINT ---
    print('---------- API REQUEST ----------');
    print('URL: $uri');
    print('---------------------------------');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 15));

      // --- RESPONSE BODY PRINT ---
      print('---------- API RESPONSE ----------');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');
      print('----------------------------------');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ProductDetailsModel.fromJson(data);
      }
      return null;
    } catch (e) {
      print('---------- API ERROR ----------');
      print('Error: $e');
      print('-------------------------------');
      return null;
    }
  }
}