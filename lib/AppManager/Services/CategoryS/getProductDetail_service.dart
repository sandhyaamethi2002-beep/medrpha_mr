import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../Models/CategoryM/getProductDetail_model.dart';

class ProductDetailService {

  Future<ProductDetailModel?> fetchProductDetails(
      String productId,
      String categoryIds,
      String adminId,
      String userTypeId,
      String areaId,
      )  async {
    try {

      final url =
          "https://mrnew.medrpha.com/api/MasterApi/GetProductDetails?pid=$productId&categoryIds=$categoryIds&adminId=$adminId&userTypeId=$userTypeId&areaId=$areaId";

      log("---  FETCHING FULL DATA FOR ID: $productId ---");

      final response = await http.get(Uri.parse(url));

      print(url);


      if (response.body.isNotEmpty) {
        debugPrint("--- API FULL RESPONSE BODY ---");
        debugPrint(response.body);
      }


      if (response.statusCode == 200) {
        return ProductDetailModel.fromJson(jsonDecode(response.body));
      } else {
        log("---  FAILED: ${response.statusCode} ---");
        return null;
      }
    } catch (e) {
      log("---  EXCEPTION: $e ---");
      return null;
    }
  }
}