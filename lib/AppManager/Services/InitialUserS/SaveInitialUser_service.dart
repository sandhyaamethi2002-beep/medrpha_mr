import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/InitialUserM/SaveInitialUser_model.dart';

class SaveInitialUserService {

  static Future<SaveInitialUserModel?> saveInitialUser(
      String phoneNo,
      int mrid,
      ) async {

    var uri = Uri.parse(
        "https://mrnew.medrpha.com/api/MasterApi/SaveInitialUser");

    var body = {
      "phoneno": phoneNo,
      "mrid": mrid
    };

    print("API URI -> $uri");
    print("Request Body -> $body");

    try {
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      print("Status Code -> ${response.statusCode}");
      print("Response Body -> ${response.body}");

      if (response.statusCode == 200) {
        return SaveInitialUserModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }

    } catch (e) {
      print("API Error -> $e");
      return null;
    }
  }
}