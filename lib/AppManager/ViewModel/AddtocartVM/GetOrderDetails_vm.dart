import 'package:get/get.dart';
import '../../Models/AddtocartM/GetOrderDetails_model.dart';
import '../../Services/AddtocartS/GetOrderDetails_service.dart';

class GetOrderDetailsVM extends GetxController {

  var isLoading = false.obs;

  var orderDetails = <OrderDetailsData>[].obs;

  final service = GetOrderDetailsService();

  Future<void> fetchOrderDetails(String orderId) async {

    try {

      isLoading.value = true;

      final response = await service.getOrderDetails(orderId);

      if (response != null && response.success == true) {

        orderDetails.value = response.data ?? [];

      }

    } catch (e) {

      print("VM ERROR : $e");

    } finally {

      isLoading.value = false;

    }

  }
}