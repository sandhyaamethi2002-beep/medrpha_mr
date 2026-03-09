import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../Models/RegistrationM/addfirm_model.dart';

class AddFirmService {

  static const String url =
      "https://mrnew.medrpha.com/api/MasterApi/AddFirm";

  static Future<AddFirmResponseModel?> addFirm({
    required Map<String, String> fields,
    required String dl1File,
    required String dl2File,
    required String pic3File,
  }) async {

    try {

      var uri = Uri.parse(url);

      print("------------ ADD FIRM API ------------");
      print("URI : $uri");
      print("REQUEST BODY : $fields");

      var request = http.MultipartRequest("POST", uri);

      request.fields.addAll(fields);

      if (dl1File.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('dl1_file', dl1File),
        );
      }

      if (dl2File.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('dl2_file', dl2File),
        );
      }

      if (pic3File.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('pic3_file', pic3File),
        );
      }

      var response = await request.send();

      var responseData = await response.stream.bytesToString();

      print("STATUS CODE : ${response.statusCode}");
      print("RESPONSE : $responseData");
      print("--------------------------------------");

      if (response.statusCode == 200) {
        return AddFirmResponseModel.fromJson(jsonDecode(responseData));
      }

      return null;

    } catch (e) {
      print("ADD FIRM ERROR : $e");
      return null;
    }
  }
}