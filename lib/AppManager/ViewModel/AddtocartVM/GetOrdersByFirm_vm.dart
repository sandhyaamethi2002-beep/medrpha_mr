import 'package:get/get.dart';
import '../../Models/AddtocartM/GetOrdersByFirm_model.dart';
import '../../Services/AddtocartS/GetOrdersByFirm_service.dart';

class GetOrdersByFirmVM extends GetxController {
  var isLoading = false.obs;
  var orderList = <OrderData>[].obs;
  // Sabhi orders ko save rakhne ke liye originalList zaruri hai
  var originalList = <OrderData>[].obs;

  Future<void> fetchOrders({
    required int firmId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      isLoading.value = true;

      final response = await GetOrdersByFirmService.getOrders(
        firmId: firmId,
        fromDate: fromDate,
        toDate: toDate,
      );

      var fetchedData = response.map<OrderData>((e) => OrderData.fromJson(e)).toList();

      // Dono lists ko update karein
      orderList.assignAll(fetchedData);
      originalList.assignAll(fetchedData);

    } catch (e) {
      print("VM ERROR => $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// --- SEARCH BY ORDER ID ONLY ---
  void searchOrders(String query) {
    // Trim se aage-piche ke spaces hat jayenge
    String cleanQuery = query.trim().toLowerCase();

    if (cleanQuery.isEmpty) {
      // Khali hone par poori list wapas dikhao
      orderList.assignAll(originalList);
    } else {
      // Sirf Order ID par filter
      var filtered = originalList.where((order) {
        final orderId = (order.orderId ?? "").toString().toLowerCase();
        return orderId.contains(cleanQuery);
      }).toList();

      orderList.assignAll(filtered);
    }
  }
}