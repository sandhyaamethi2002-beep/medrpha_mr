import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/InitialUserM/GetInitialRegistrationsByMrId_model.dart';

class GetInitialRegistrationsByMrIdService {

  Future<GetInitialRegistrationsByMrIdModel?> getUsers(int mrid) async {

    final uri = Uri.parse(
        "https://mrnew.medrpha.com/api/MasterApi/GetInitialRegistrationsByMrId?mrid=$mrid");

    try {

      print("-------------API CALL-------------");
      print("URI : $uri");
      print("REQUEST : mrid=$mrid");

      final response = await http.get(uri);

      print("STATUS CODE : ${response.statusCode}");
      print("RESPONSE : ${response.body}");
      print("----------------------------------");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return GetInitialRegistrationsByMrIdModel.fromJson(jsonData);
      } else {
        return null;
      }

    } catch (e) {
      print("API ERROR : $e");
      return null;
    }
  }
}