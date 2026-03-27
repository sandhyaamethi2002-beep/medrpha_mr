import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/AddtocartM/DeleteCartById_model.dart';

class DeleteCartByIdService {
  Future<DeleteCartByIdModel?> deleteCart({
    required int cartId,
    required int userTypeId,
  }) async {
    // URL path mein parameters ko String mein parse karke bhejna zyada safe hota hai
    final String url = "https://mrnew.medrpha.com/api/Cart/DeleteCartById/${cartId.toString()}/${userTypeId.toString()}";

    print("--- API CALL START ---");
    print("URL: $url");
    print("Method: DELETE"); // 405 error ki wajah se hum wapas DELETE use kar rahe hain

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          // Agar aapki app mein Token use hota hai toh niche wali line uncomment karein:
          // "Authorization": "Bearer YOUR_TOKEN",
        },
      );

      print("STATUS CODE => ${response.statusCode}");
      print("RESPONSE BODY => ${response.body}");

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final jsonData = jsonDecode(response.body);
          return DeleteCartByIdModel.fromJson(jsonData);
        } else {
          print("API Success but empty body");
          return DeleteCartByIdModel(success: true, message: "Deleted successfully");
        }
      } else if (response.statusCode == 400) {
        print("ERROR 400: Check if CartID $cartId exists in DB for UserType $userTypeId");
        return null;
      } else {
        print("API FAILED: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("NETWORK ERROR (Delete) => $e");
      return null;
    }
  }
}