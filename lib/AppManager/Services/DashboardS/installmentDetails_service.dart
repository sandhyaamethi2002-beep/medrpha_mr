import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/DashboardM/installmentDetails_model.dart';

class InstallmentDetailsService {

  static Future<InstallmentDetailsModel?> getInstallmentDetails(int mrid) async {

    final uri = Uri.parse(
        "https://mrnew.medrpha.com/api/MasterApi/installment-details?mrid=$mrid");

    print("----------- API CALL -----------");
    print("URI => $uri");
    print("Request => mrid : $mrid");

    try {

      final response = await http.get(uri);

      print("Status Code => ${response.statusCode}");
      print("Response => ${response.body}");

      if (response.statusCode == 200) {

        final jsonData = jsonDecode(response.body);

        return InstallmentDetailsModel.fromJson(jsonData);

      } else {
        print("API ERROR");
        return null;
      }

    } catch (e) {
      print("Exception => $e");
      return null;
    }
  }

  static Future<dynamic> fetchInstallmentDetails(int mrid) async {}
}