import 'package:get/get.dart';
import '../../Models/AddtocartM/GetOrderInvoice_model.dart';
import '../../Services/AddtocartS/GetOrderInvoice_service.dart';


class GetOrderInvoiceVM extends GetxController {

  var isLoading = false.obs;

  var invoiceList = <InvoiceData>[].obs;

  final service = GetOrderInvoiceService();

  Future fetchInvoice(int orderId) async {

    isLoading.value = true;

    final result = await service.getOrderInvoice(orderId);

    if (result != null && result.data != null) {
      invoiceList.value = result.data!;
    }

    isLoading.value = false;
  }
}